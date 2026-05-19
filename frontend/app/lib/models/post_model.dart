import 'post_media_model.dart';

class PostModel {
  final String postId;
  final String author;
  final String university;
  final String content;
  final String type;
  final List<String> tags;
  final String timeAgo;
  final int likes;
  final bool isLiked;

  final Map<String, int> reactions;
  final String currentReaction;

  final List<PostMediaModel> media;

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
    this.reactions = const {},
    this.currentReaction = "",
    this.media = const [],
  });

  PostModel copyWith({
    String? postId,
    String? author,
    String? university,
    String? content,
    String? type,
    List<String>? tags,
    String? timeAgo,
    int? likes,
    bool? isLiked,
    Map<String, int>? reactions,
    String? currentReaction,
    List<PostMediaModel>? media,
  }) {
    return PostModel(
      postId: postId ?? this.postId,
      author: author ?? this.author,
      university: university ?? this.university,
      content: content ?? this.content,
      type: type ?? this.type,
      tags: tags ?? this.tags,
      timeAgo: timeAgo ?? this.timeAgo,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      reactions: reactions ?? this.reactions,
      currentReaction: currentReaction ?? this.currentReaction,
      media: media ?? this.media,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "postId": postId,
      "author": author,
      "university": university,
      "content": content,
      "type": type,
      "tags": tags,
      "timeAgo": timeAgo,
      "likes": likes,
      "isLiked": isLiked,
      "reactions": reactions,
      "currentReaction": currentReaction,
      "media": media.map((item) => item.toJson()).toList(),
    };
  }

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      postId: json["postId"] ?? "",
      author: json["author"] ?? "",
      university: json["university"] ?? "",
      content: json["content"] ?? "",
      type: json["type"] ?? "",
      tags: List<String>.from(json["tags"] ?? []),
      timeAgo: json["timeAgo"] ?? "",
      likes: json["likes"] ?? 0,
      isLiked: json["isLiked"] ?? false,
      reactions: Map<String, int>.from(json["reactions"] ?? {}),
      currentReaction: json["currentReaction"] ?? "",
      media: (json["media"] as List<dynamic>? ?? [])
          .map((item) => PostMediaModel.fromJson(item))
          .toList(),
    );
  }
}
