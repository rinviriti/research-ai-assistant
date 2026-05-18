import '../models/comment_model.dart';
import 'notification_service.dart';

class CommentService {
  static final List<CommentModel> comments = [];

  static List<CommentModel> getCommentsForPost(String postAuthor) {
    return comments
        .where((comment) => comment.postAuthor == postAuthor)
        .toList();
  }

  static void addComment({
    required String postAuthor,
    required String commenter,
    required String comment,
  }) {
    comments.add(
      CommentModel(
        postAuthor: postAuthor,
        commenter: commenter,
        comment: comment,
        timeAgo: "Just now",
      ),
    );

    NotificationService.addNotification(
      title: "New Research Comment",
      body: "$commenter commented on a research discussion.",
      type: "comment",
    );
  }

  static void deleteComment(CommentModel commentModel) {
    comments.remove(commentModel);

    NotificationService.addNotification(
      title: "Comment Removed",
      body: "A research discussion comment was removed.",
      type: "comment",
    );
  }

  static int commentCount(String postAuthor) {
    return comments.where((comment) => comment.postAuthor == postAuthor).length;
  }

  static void clearComments() {
    comments.clear();

    NotificationService.addNotification(
      title: "Comments Cleared",
      body: "All research discussion comments were cleared.",
      type: "comment",
    );
  }
}
