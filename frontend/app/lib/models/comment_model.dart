class CommentModel {
  final String postAuthor;
  final String commenter;
  final String comment;
  final String timeAgo;

  CommentModel({
    required this.postAuthor,
    required this.commenter,
    required this.comment,
    required this.timeAgo,
  });
}
