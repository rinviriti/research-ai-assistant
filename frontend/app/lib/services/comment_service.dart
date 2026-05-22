import 'dart:async';

import '../models/comment_model.dart';
import 'local_storage_service.dart';
import 'notification_service.dart';
import 'post_service.dart';
import 'session_service.dart';

class CommentService {
  static final List<CommentModel> comments = [];

  static final StreamController<List<CommentModel>> _controller =
      StreamController<List<CommentModel>>.broadcast();

  static const String storageKey = "rh_comments";

  static Stream<List<CommentModel>> get stream {
    Future.microtask(sync);
    return _controller.stream;
  }

  static void sync() {
    if (!_controller.isClosed) {
      _controller.add(List<CommentModel>.from(comments));
    }

    saveComments();
  }

  static Future<void> loadComments() async {
    final data = await LocalStorageService.getJson(storageKey);

    if (data == null) return;

    comments.clear();

    comments.addAll(
      (data as List)
          .map((item) => CommentModel.fromJson(Map<String, dynamic>.from(item)))
          .toList(),
    );

    sync();
  }

  static Future<void> saveComments() async {
    await LocalStorageService.saveJson(
      key: storageKey,
      data: comments.map((comment) => comment.toJson()).toList(),
    );
  }

  static List<CommentModel> getCommentsForPost(String postId) {
    final postComments = comments
        .where(
          (comment) =>
              comment.postId == postId && comment.parentCommentId == null,
        )
        .toList();

    postComments.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return postComments;
  }

  static List<CommentModel> getRepliesForComment(String commentId) {
    final replies = comments
        .where((comment) => comment.parentCommentId == commentId)
        .toList();

    replies.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    return replies;
  }

  static void addComment({
    required String postId,
    required String commenter,
    required String comment,
  }) {
    final now = DateTime.now();

    comments.add(
      CommentModel(
        commentId: now.microsecondsSinceEpoch.toString(),
        postId: postId,
        commenterId: SessionService.currentUser?.userId ?? "local_user",
        commenter: commenter,
        comment: comment,
        createdAt: now,
      ),
    );

    PostService.incrementCommentCount(postId);

    NotificationService.addNotification(
      title: "New Research Comment",
      body: "$commenter commented on a research discussion.",
      type: "comment",
      targetId: postId,
      targetName: commenter,
      payload: {"postId": postId, "commenter": commenter},
    );

    sync();
  }

  static void addReply({
    required String postId,
    required String parentCommentId,
    required String commenter,
    required String reply,
  }) {
    final now = DateTime.now();

    comments.add(
      CommentModel(
        commentId: now.microsecondsSinceEpoch.toString(),
        postId: postId,
        commenterId: SessionService.currentUser?.userId ?? "local_user",
        commenter: commenter,
        comment: reply,
        createdAt: now,
        parentCommentId: parentCommentId,
      ),
    );

    PostService.incrementCommentCount(postId);

    NotificationService.addNotification(
      title: "New Comment Reply",
      body: "$commenter replied to a research comment.",
      type: "comment",
      targetId: postId,
      targetName: commenter,
      payload: {
        "postId": postId,
        "commenter": commenter,
        "parentCommentId": parentCommentId,
      },
    );

    sync();
  }

  static int commentCount(String postId) {
    return comments.where((comment) => comment.postId == postId).length;
  }

  static int replyCount(String commentId) {
    return comments
        .where((comment) => comment.parentCommentId == commentId)
        .length;
  }

  static void clearComments() {
    comments.clear();
    sync();
  }
}
