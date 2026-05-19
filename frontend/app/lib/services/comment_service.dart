import '../models/comment_model.dart';
import 'notification_service.dart';

class CommentService {
  static final List<CommentModel> comments = [];

  static List<CommentModel> getCommentsForPost(String postId) {
    return comments.where((comment) => comment.postId == postId).toList();
  }

  static void addComment({
    required String postId,
    required String commenter,
    required String comment,
  }) {
    comments.add(
      CommentModel(
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

  static int commentCount(String postId) {
    return comments.where((comment) => comment.postId == postId).length;
  }

  static void clearComments() {
    comments.clear();
  }
}
