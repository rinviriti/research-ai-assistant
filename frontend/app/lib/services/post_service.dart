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

  static void toggleLike(String postId) {
    final index = posts.indexWhere((post) => post.postId == postId);

    if (index == -1) return;

    final post = posts[index];

    if (post.isLiked) {
      post.likes--;
      post.isLiked = false;
    } else {
      post.likes++;
      post.isLiked = true;

      NotificationService.addNotification(
        title: "Research Post Liked",
        body: "You reacted to a research discussion.",
        type: "post",
        targetId: post.postId,
        targetName: post.author,
      );
    }
  }

  static PostModel? getPostById(String postId) {
    try {
      return posts.firstWhere((post) => post.postId == postId);
    } catch (e) {
      return null;
    }
  }

  static void clearPosts() {
    posts.clear();
  }
}
