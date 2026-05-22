class SavedPostModel {
  final String savedId;
  final String postId;

  final String postAuthor;
  final String postContent;

  final String savedBy;
  final String savedById;

  final DateTime createdAt;

  SavedPostModel({
    required this.savedById,
    required this.savedId,
    required this.postId,
    required this.postAuthor,
    required this.postContent,
    required this.savedBy,
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
      "savedById": savedById,
      "savedId": savedId,
      "postId": postId,
      "postAuthor": postAuthor,
      "postContent": postContent,
      "savedBy": savedBy,
      "createdAt": createdAt.toIso8601String(),
    };
  }

  factory SavedPostModel.fromJson(Map<String, dynamic> json) {
    return SavedPostModel(
      savedById: json["savedById"] ?? "",
      savedId: json["savedId"] ?? "",
      postId: json["postId"] ?? "",
      postAuthor: json["postAuthor"] ?? "",
      postContent: json["postContent"] ?? "",
      savedBy: json["savedBy"] ?? "",
      createdAt: DateTime.tryParse(json["createdAt"] ?? "") ?? DateTime.now(),
    );
  }
}
