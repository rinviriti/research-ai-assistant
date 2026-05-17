import '../models/comment_model.dart';

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
  }
}
