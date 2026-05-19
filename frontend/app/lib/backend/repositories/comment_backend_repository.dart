import '../../models/comment_model.dart';
import '../../services/comment_service.dart';
import '../mock_backend/mock_database.dart';

class CommentBackendRepository {
  Future<List<CommentModel>> getComments(String postId) async {
    return CommentService.getCommentsForPost(postId);
  }

  Future<List<CommentModel>> getReplies(String commentId) async {
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
        "commentId": DateTime.now().millisecondsSinceEpoch.toString(),
        "postId": postId,
        "commenter": commenter,
        "comment": comment,
        "timeAgo": "Just now",
        "parentCommentId": null,
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
        "commentId": DateTime.now().microsecondsSinceEpoch.toString(),
        "postId": postId,
        "commenter": commenter,
        "comment": reply,
        "timeAgo": "Just now",
        "parentCommentId": parentCommentId,
      },
    );
  }

  Future<int> commentCount(String postId) async {
    return CommentService.commentCount(postId);
  }

  Future<int> replyCount(String commentId) async {
    return CommentService.replyCount(commentId);
  }

  Map<String, dynamic> toBackendPayload(CommentModel comment) {
    return {
      "commentId": comment.commentId,
      "postId": comment.postId,
      "commenter": comment.commenter,
      "comment": comment.comment,
      "timeAgo": comment.timeAgo,
      "parentCommentId": comment.parentCommentId,
    };
  }

  CommentModel fromBackendPayload(Map<String, dynamic> data) {
    return CommentModel(
      commentId: data["commentId"] ?? "",
      postId: data["postId"] ?? "",
      commenter: data["commenter"] ?? "",
      comment: data["comment"] ?? "",
      timeAgo: data["timeAgo"] ?? "",
      parentCommentId: data["parentCommentId"],
    );
  }
}
