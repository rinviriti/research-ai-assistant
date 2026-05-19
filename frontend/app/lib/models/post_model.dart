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

  String currentReaction;

  Map<String, int> reactions;

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
    this.currentReaction = "",
    Map<String, int>? reactions,
  }) : reactions =
           reactions ??
           {
             "like": 0,
             "support": 0,
             "celebrate": 0,
             "insightful": 0,
             "applaud": 0,
           };
}
