class ShareModel {
  final String shareId;
  final String postId;
  final String originalAuthor;
  final String sharedBy;
  final String content;
  final String? quote;
  final String timeAgo;

  ShareModel({
    required this.shareId,
    required this.postId,
    required this.originalAuthor,
    required this.sharedBy,
    required this.content,
    this.quote,
    required this.timeAgo,
  });
}
