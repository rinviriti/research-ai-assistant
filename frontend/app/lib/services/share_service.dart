import '../models/share_model.dart';
import '../models/post_model.dart';
import 'notification_service.dart';
import 'post_service.dart';

class ShareService {
  static final List<ShareModel> shares = [];

  static List<ShareModel> getSharesForPost(String postId) {
    return shares.where((share) => share.postId == postId).toList();
  }

  static int shareCount(String postId) {
    return shares.where((share) => share.postId == postId).length;
  }

  static void sharePost({
    required PostModel post,
    required String sharedBy,
    String? quote,
  }) {
    final share = ShareModel(
      shareId: DateTime.now().microsecondsSinceEpoch.toString(),
      postId: post.postId,
      originalAuthor: post.author,
      sharedBy: sharedBy,
      content: post.content,
      quote: quote,
      timeAgo: "Just now",
    );

    shares.insert(0, share);

    final repost = PostModel(
      postId: "share_${share.shareId}",
      author: sharedBy,
      university: "Your University",
      content: quote == null || quote.trim().isEmpty
          ? "Shared ${post.author}'s research post:\n\n${post.content}"
          : "$quote\n\nShared ${post.author}'s research post:\n\n${post.content}",
      type: "Shared Research",
      tags: post.tags,
      createdAt: DateTime.now(),
      likes: 0,
    );

    PostService.addPost(repost);

    NotificationService.addNotification(
      title: "Research Post Shared",
      body: "$sharedBy shared ${post.author}'s research post.",
      type: "post",
      targetId: post.postId,
      targetName: post.author,
    );
  }

  static void clearShares() {
    shares.clear();
  }
}
