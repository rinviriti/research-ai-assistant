class CommentModel {
  final String commentId;
  final String postId;
  final String commenter;
  final String comment;
  final String timeAgo;
  final String? parentCommentId;

  CommentModel({
    required this.commentId,
    required this.postId,
    required this.commenter,
    required this.comment,
    required this.timeAgo,
    this.parentCommentId,
  });
}
