import '../models/comment_model.dart';
import 'notification_service.dart';

class CommentService {
  static final List<CommentModel> comments = [];

  static List<CommentModel> getCommentsForPost(String postId) {
    return comments
        .where(
          (comment) =>
              comment.postId == postId && comment.parentCommentId == null,
        )
        .toList();
  }

  static List<CommentModel> getRepliesForComment(String commentId) {
    return comments
        .where((comment) => comment.parentCommentId == commentId)
        .toList();
  }

  static void addComment({
    required String postId,
    required String commenter,
    required String comment,
  }) {
    final commentId = DateTime.now().millisecondsSinceEpoch.toString();

    comments.add(
      CommentModel(
        commentId: commentId,
        postId: postId,
        commenter: commenter,
        comment: comment,
        timeAgo: "Just now",
      ),
    );

    NotificationService.addNotification(
      title: "New Research Comment",
      body: "$commenter commented on a research discussion.",
      type: "comment",
      targetId: postId,
      targetName: commenter,
    );
  }

  static void addReply({
    required String postId,
    required String parentCommentId,
    required String commenter,
    required String reply,
  }) {
    final replyId = DateTime.now().microsecondsSinceEpoch.toString();

    comments.add(
      CommentModel(
        commentId: replyId,
        postId: postId,
        commenter: commenter,
        comment: reply,
        timeAgo: "Just now",
        parentCommentId: parentCommentId,
      ),
    );

    NotificationService.addNotification(
      title: "New Comment Reply",
      body: "$commenter replied to a research comment.",
      type: "comment",
      targetId: postId,
      targetName: commenter,
    );
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
  }
}
