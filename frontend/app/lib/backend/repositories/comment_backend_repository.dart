import '../../models/comment_model.dart';
import '../../services/comment_service.dart';
import '../mock_backend/mock_database.dart';

class CommentBackendRepository {
  Future<List<CommentModel>> getComments(String postId) async {
    await CommentService.loadComments();
    return CommentService.getCommentsForPost(postId);
  }

  Future<List<CommentModel>> getReplies(String commentId) async {
    await CommentService.loadComments();
    return CommentService.getRepliesForComment(commentId);
  }

  Future<void> addComment({
    required String postId,
    required String commenter,
    required String comment,
  }) async {
    CommentService.addComment(
      postId: postId,
      commenter: commenter,
      comment: comment,
    );

    await MockDatabase.addDocument(
      collection: "comments",
      data: {
        "postId": postId,
        "commenter": commenter,
        "comment": comment,
        "parentCommentId": null,
        "createdAt": DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> addReply({
    required String postId,
    required String parentCommentId,
    required String commenter,
    required String reply,
  }) async {
    CommentService.addReply(
      postId: postId,
      parentCommentId: parentCommentId,
      commenter: commenter,
      reply: reply,
    );

    await MockDatabase.addDocument(
      collection: "comments",
      data: {
        "postId": postId,
        "commenter": commenter,
        "comment": reply,
        "parentCommentId": parentCommentId,
        "createdAt": DateTime.now().toIso8601String(),
      },
    );
  }

  Future<int> commentCount(String postId) async {
    return CommentService.commentCount(postId);
  }

  Future<int> replyCount(String commentId) async {
    return CommentService.replyCount(commentId);
  }

  Stream<List<CommentModel>> watchComments() {
    return CommentService.stream;
  }

  Map<String, dynamic> toBackendPayload(CommentModel comment) {
    return comment.toJson();
  }

  CommentModel fromBackendPayload(Map<String, dynamic> data) {
    return CommentModel.fromJson(data);
  }
}
