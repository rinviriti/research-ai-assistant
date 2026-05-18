import '../../models/comment_model.dart';
import '../../services/comment_service.dart';
import '../mock_backend/mock_database.dart';

class CommentBackendRepository {
  Future<List<CommentModel>> getComments(String postId) async {
    return CommentService.getCommentsForPost(postId);
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
        "timeAgo": "Just now",
      },
    );
  }

  Future<int> commentCount(String postId) async {
    return CommentService.commentCount(postId);
  }

  Map<String, dynamic> toBackendPayload(CommentModel comment) {
    return {
      "postId": comment.postId,
      "commenter": comment.commenter,
      "comment": comment.comment,
      "timeAgo": comment.timeAgo,
    };
  }

  CommentModel fromBackendPayload(Map<String, dynamic> data) {
    return CommentModel(
      postId: data["postId"] ?? "",
      commenter: data["commenter"] ?? "",
      comment: data["comment"] ?? "",
      timeAgo: data["timeAgo"] ?? "",
    );
  }
}
