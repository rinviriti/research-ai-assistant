import '../models/post_model.dart';
import 'notification_service.dart';

class PostService {
  static final List<PostModel> posts = [
    PostModel(
      postId: "post_001",
      author: "Rinvi Jaman Riti",
      university: "Daffodil International University",
      content:
          "Testing Swin-UNet++ on MRI segmentation dataset. Current Dice score reached 0.91. Looking for suggestions to improve ET segmentation performance.",
      type: "Ongoing Research",
      tags: ["Medical Imaging", "Segmentation", "Deep Learning"],
      timeAgo: "2h ago",
      likes: 12,
      reactions: {
        "like": 8,
        "support": 2,
        "celebrate": 1,
        "insightful": 1,
        "applaud": 0,
      },
    ),
    PostModel(
      postId: "post_002",
      author: "Dr. Aiko Tanaka",
      university: "University of Tokyo",
      content:
          "Published new paper on AI-assisted clinical diagnosis using multimodal MRI analysis.",
      type: "Publication",
      tags: ["Clinical AI", "MRI", "Healthcare"],
      timeAgo: "5h ago",
      likes: 31,
      reactions: {
        "like": 18,
        "support": 4,
        "celebrate": 5,
        "insightful": 3,
        "applaud": 1,
      },
    ),
  ];

  static void addPost(PostModel post) {
    posts.insert(0, post);

    NotificationService.addNotification(
      title: "Research Post Created",
      body: "${post.author} published a new research post.",
      type: "post",
      targetId: post.postId,
      targetName: post.author,
    );
  }

  static PostModel? getPostById(String postId) {
    try {
      return posts.firstWhere((post) => post.postId == postId);
    } catch (e) {
      return null;
    }
  }

  static int totalReactions(PostModel post) {
    return post.reactions.values.fold(
      0,
      (previousValue, count) => previousValue + count,
    );
  }

  static void setReaction({
    required String postId,
    required String reactionType,
  }) {
    final post = getPostById(postId);

    if (post == null) return;

    final previousReaction = post.currentReaction;

    if (previousReaction == reactionType) {
      post.reactions[reactionType] = (post.reactions[reactionType] ?? 1) - 1;

      if ((post.reactions[reactionType] ?? 0) < 0) {
        post.reactions[reactionType] = 0;
      }

      post.currentReaction = "";
      post.isLiked = false;
      post.likes = totalReactions(post);
      return;
    }

    if (previousReaction.isNotEmpty) {
      post.reactions[previousReaction] =
          (post.reactions[previousReaction] ?? 1) - 1;

      if ((post.reactions[previousReaction] ?? 0) < 0) {
        post.reactions[previousReaction] = 0;
      }
    }

    post.reactions[reactionType] = (post.reactions[reactionType] ?? 0) + 1;

    post.currentReaction = reactionType;
    post.isLiked = true;
    post.likes = totalReactions(post);

    NotificationService.addNotification(
      title: "Research Post Reaction",
      body: "You reacted to a research discussion.",
      type: "post",
      targetId: post.postId,
      targetName: post.author,
    );
  }

  static void toggleLike(String postId) {
    setReaction(postId: postId, reactionType: "like");
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

    return "Like";
  }

  static void clearPosts() {
    posts.clear();
  }
}
