class PostModel {
  final String postId;
  final String author;
  final String university;
  final String content;
  final String type;
  final List<String> tags;
  final String timeAgo;
  int likes;
  bool isLiked;

  PostModel({
    required this.postId,
    required this.author,
    required this.university,
    required this.content,
    required this.type,
    required this.tags,
    required this.timeAgo,
    required this.likes,
    this.isLiked = false,
  });
}
