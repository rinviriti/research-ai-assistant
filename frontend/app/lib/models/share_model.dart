class ShareModel {
  final String shareId;

  final String postId;

  final String originalAuthor;

  final String sharedBy;

  final String content;

  final String? quote;

  final DateTime createdAt;

  ShareModel({
    required this.shareId,
    required this.postId,
    required this.originalAuthor,
    required this.sharedBy,
    required this.content,
    this.quote,
    required this.createdAt,
  });

  String get timeAgo {
    final difference = DateTime.now().difference(createdAt);

    if (difference.inSeconds < 60) return "Just now";
    if (difference.inMinutes < 60) return "${difference.inMinutes}m ago";
    if (difference.inHours < 24) return "${difference.inHours}h ago";
    if (difference.inDays < 7) return "${difference.inDays}d ago";

    return "${createdAt.day}/${createdAt.month}/${createdAt.year}";
  }

  Map<String, dynamic> toJson() {
    return {
      "shareId": shareId,
      "postId": postId,
      "originalAuthor": originalAuthor,
      "sharedBy": sharedBy,
      "content": content,
      "quote": quote,
      "createdAt": createdAt.toIso8601String(),
    };
  }

  factory ShareModel.fromJson(Map<String, dynamic> json) {
    return ShareModel(
      shareId: json["shareId"] ?? "",
      postId: json["postId"] ?? "",
      originalAuthor: json["originalAuthor"] ?? "",
      sharedBy: json["sharedBy"] ?? "",
      content: json["content"] ?? "",
      quote: json["quote"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? "") ?? DateTime.now(),
    );
  }
}
