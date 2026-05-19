import '../models/post_model.dart';

class PostService {
  static final List<PostModel> posts = [];

  static List<PostModel> getPosts() {
    return posts;
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
  }

  static void clearPosts() {
    posts.clear();
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

      posts[index] = post.copyWith(
        reactions: updatedReactions,
        currentReaction: "",
        likes: totalReactions(post.copyWith(reactions: updatedReactions)),
        isLiked: false,
      );

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

    posts[index] = post.copyWith(
      reactions: updatedReactions,
      currentReaction: reactionType,
      likes: totalReactions(post.copyWith(reactions: updatedReactions)),
      isLiked: true,
    );
  }
}
