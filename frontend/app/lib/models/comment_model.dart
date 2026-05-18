class CommentModel {
  final String postId;
  final String commenter;
  final String comment;
  final String timeAgo;

  CommentModel({
    required this.postId,
    required this.commenter,
    required this.comment,
    required this.timeAgo,
  });
}
