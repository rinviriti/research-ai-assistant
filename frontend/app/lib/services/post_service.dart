import 'dart:async';

import '../models/post_model.dart';
import 'local_storage_service.dart';

class PostService {
  static final List<PostModel> posts = [];

  static final StreamController<List<PostModel>> _controller =
      StreamController<List<PostModel>>.broadcast();

  static const String storageKey = "rh_posts";

  static Stream<List<PostModel>> get stream {
    Future.microtask(sync);
    return _controller.stream;
  }

  static void sync() {
    if (!_controller.isClosed) {
      _controller.add(List<PostModel>.from(posts));
    }

    savePosts();
  }

  static Future<void> loadPosts() async {
    final data = await LocalStorageService.getJson(storageKey);

    if (data == null) return;

    posts.clear();

    posts.addAll(
      (data as List)
          .map((item) => PostModel.fromJson(Map<String, dynamic>.from(item)))
          .toList(),
    );

    sync();
  }

  static Future<void> savePosts() async {
    await LocalStorageService.saveJson(
      key: storageKey,
      data: posts.map((post) => post.toJson()).toList(),
    );
  }

  static List<PostModel> getPosts() {
    posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return List<PostModel>.from(posts);
  }

  static List<PostModel> getSavedPosts() {
    return posts.where((post) => post.isBookmarked).toList();
  }

  static PostModel? getPostById(String postId) {
    try {
      return posts.firstWhere((post) => post.postId == postId);
    } catch (_) {
      return null;
    }
  }

  static void addPost(PostModel post) {
    posts.insert(0, post);
    sync();
  }

  static void clearPosts() {
    posts.clear();
    sync();
  }

  static int totalReactions(PostModel post) {
    return post.reactions.values.fold(0, (total, count) => total + count);
  }

  static String reactionEmoji(String reactionType) {
    if (reactionType == "like") return "👍";
    if (reactionType == "support") return "❤️";
    if (reactionType == "celebrate") return "🎉";
    if (reactionType == "insightful") return "💡";
    if (reactionType == "applaud") return "👏";

    return "👍";
  }

  static String reactionLabel(String reactionType) {
    if (reactionType == "like") return "Like";
    if (reactionType == "support") return "Support";
    if (reactionType == "celebrate") return "Celebrate";
    if (reactionType == "insightful") return "Insightful";
    if (reactionType == "applaud") return "Applaud";

    return "React";
  }

  static void setReaction({
    required String postId,
    required String reactionType,
  }) {
    final index = posts.indexWhere((post) => post.postId == postId);

    if (index == -1) return;

    final post = posts[index];

    final updatedReactions = Map<String, int>.from(post.reactions);

    if (post.currentReaction == reactionType) {
      updatedReactions[reactionType] =
          (updatedReactions[reactionType] ?? 1) - 1;

      if ((updatedReactions[reactionType] ?? 0) <= 0) {
        updatedReactions.remove(reactionType);
      }

      final updatedPost = post.copyWith(
        reactions: updatedReactions,
        currentReaction: "",
        likes: totalReactions(post.copyWith(reactions: updatedReactions)),
        isLiked: false,
      );

      posts[index] = updatedPost;
      sync();
      return;
    }

    if (post.currentReaction.isNotEmpty) {
      updatedReactions[post.currentReaction] =
          (updatedReactions[post.currentReaction] ?? 1) - 1;

      if ((updatedReactions[post.currentReaction] ?? 0) <= 0) {
        updatedReactions.remove(post.currentReaction);
      }
    }

    updatedReactions[reactionType] = (updatedReactions[reactionType] ?? 0) + 1;

    final updatedPost = post.copyWith(
      reactions: updatedReactions,
      currentReaction: reactionType,
      likes: totalReactions(post.copyWith(reactions: updatedReactions)),
      isLiked: true,
    );

    posts[index] = updatedPost;
    sync();
  }

  static void toggleBookmark(String postId) {
    final index = posts.indexWhere((post) => post.postId == postId);

    if (index == -1) return;

    final post = posts[index];

    posts[index] = post.copyWith(isBookmarked: !post.isBookmarked);

    sync();
  }

  static void incrementCommentCount(String postId) {
    final index = posts.indexWhere((post) => post.postId == postId);

    if (index == -1) return;

    final post = posts[index];

    posts[index] = post.copyWith(commentCount: post.commentCount + 1);

    sync();
  }
}
