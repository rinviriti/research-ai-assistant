import 'post_media_model.dart';

class PostModel {
  final String postId;

  // =========================================
  // USER INFO
  // =========================================

  final String authorId;
  final String author;

  final String university;

  // =========================================
  // CONTENT
  // =========================================

  final String content;
  final String type;

  final List<String> tags;

  final DateTime createdAt;

  // =========================================
  // ENGAGEMENT
  // =========================================

  final int likes;

  final bool isLiked;

  final List<String> likedBy;

  final Map<String, int> reactions;

  final String currentReaction;

  final int commentCount;

  final bool isBookmarked;

  // =========================================
  // MEDIA
  // =========================================

  final List<PostMediaModel> media;

  PostModel({
    required this.postId,

    required this.authorId,
    required this.author,

    required this.university,

    required this.content,
    required this.type,

    required this.tags,

    required this.createdAt,

    required this.likes,

    this.isLiked = false,

    this.likedBy = const [],

    this.reactions = const {},

    this.currentReaction = "",

    this.commentCount = 0,

    this.isBookmarked = false,

    this.media = const [],
  });

  String get timeAgo {
    final difference = DateTime.now().difference(createdAt);

    if (difference.inSeconds < 60) {
      return "Just now";
    }

    if (difference.inMinutes < 60) {
      return "${difference.inMinutes}m ago";
    }

    if (difference.inHours < 24) {
      return "${difference.inHours}h ago";
    }

    if (difference.inDays < 7) {
      return "${difference.inDays}d ago";
    }

    return "${createdAt.day}/${createdAt.month}/${createdAt.year}";
  }

  PostModel copyWith({
    String? postId,

    String? authorId,
    String? author,

    String? university,

    String? content,
    String? type,

    List<String>? tags,

    DateTime? createdAt,

    int? likes,

    bool? isLiked,

    List<String>? likedBy,

    Map<String, int>? reactions,

    String? currentReaction,

    int? commentCount,

    bool? isBookmarked,

    List<PostMediaModel>? media,
  }) {
    return PostModel(
      postId: postId ?? this.postId,

      authorId: authorId ?? this.authorId,
      author: author ?? this.author,

      university: university ?? this.university,

      content: content ?? this.content,
      type: type ?? this.type,

      tags: tags ?? this.tags,

      createdAt: createdAt ?? this.createdAt,

      likes: likes ?? this.likes,

      isLiked: isLiked ?? this.isLiked,

      likedBy: likedBy ?? this.likedBy,

      reactions: reactions ?? this.reactions,

      currentReaction: currentReaction ?? this.currentReaction,

      commentCount: commentCount ?? this.commentCount,

      isBookmarked: isBookmarked ?? this.isBookmarked,

      media: media ?? this.media,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "postId": postId,

      "authorId": authorId,
      "author": author,

      "university": university,

      "content": content,
      "type": type,

      "tags": tags,

      "createdAt": createdAt.toIso8601String(),

      "likes": likes,

      "isLiked": isLiked,

      "likedBy": likedBy,

      "reactions": reactions,

      "currentReaction": currentReaction,

      "commentCount": commentCount,

      "isBookmarked": isBookmarked,

      "media": media.map((item) => item.toJson()).toList(),
    };
  }

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      postId: json["postId"] ?? "",

      authorId: json["authorId"] ?? "",
      author: json["author"] ?? "",

      university: json["university"] ?? "",

      content: json["content"] ?? "",
      type: json["type"] ?? "",

      tags: List<String>.from(json["tags"] ?? []),

      createdAt: DateTime.tryParse(json["createdAt"] ?? "") ?? DateTime.now(),

      likes: json["likes"] ?? 0,

      isLiked: json["isLiked"] ?? false,

      likedBy: List<String>.from(json["likedBy"] ?? []),

      reactions: Map<String, int>.from(json["reactions"] ?? {}),

      currentReaction: json["currentReaction"] ?? "",

      commentCount: json["commentCount"] ?? 0,

      isBookmarked: json["isBookmarked"] ?? false,

      media: (json["media"] as List<dynamic>? ?? [])
          .map((item) => PostMediaModel.fromJson(item))
          .toList(),
    );
  }
}
