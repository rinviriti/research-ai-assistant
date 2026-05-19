class SavedPostModel {
  final String savedId;
  final String postId;
  final String postAuthor;
  final String postContent;
  final String savedBy;
  final String timeAgo;

  SavedPostModel({
    required this.savedId,
    required this.postId,
    required this.postAuthor,
    required this.postContent,
    required this.savedBy,
    required this.timeAgo,
  });
}
