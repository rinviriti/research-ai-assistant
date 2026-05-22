class CommentModel {
  final String commentId;
  final String postId;
  final String commenterId;
  final String commenter;
  final String comment;
  final DateTime createdAt;
  final String? parentCommentId;

  CommentModel({
    required this.commentId,
    required this.postId,
    required this.commenterId,
    required this.commenter,
    required this.comment,
    required this.createdAt,
    this.parentCommentId,
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
      "commentId": commentId,
      "postId": postId,
      "commenterId": commenterId,
      "commenter": commenter,
      "comment": comment,
      "createdAt": createdAt.toIso8601String(),
      "parentCommentId": parentCommentId,
    };
  }

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      commentId: json["commentId"] ?? "",
      postId: json["postId"] ?? "",
      commenterId: json["commenterId"] ?? "",
      commenter: json["commenter"] ?? "",
      comment: json["comment"] ?? "",
      createdAt: DateTime.tryParse(json["createdAt"] ?? "") ?? DateTime.now(),
      parentCommentId: json["parentCommentId"],
    );
  }
}
