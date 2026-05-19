import '../../models/post_model.dart';
import '../../models/share_model.dart';
import '../../services/share_service.dart';
import '../mock_backend/mock_database.dart';

class ShareBackendRepository {
  Future<List<ShareModel>> getSharesForPost(String postId) async {
    return ShareService.getSharesForPost(postId);
  }

  Future<int> shareCount(String postId) async {
    return ShareService.shareCount(postId);
  }

  Future<void> sharePost({
    required PostModel post,
    required String sharedBy,
    String? quote,
  }) async {
    ShareService.sharePost(post: post, sharedBy: sharedBy, quote: quote);

    await MockDatabase.addDocument(
      collection: "shares",
      data: {
        "shareId": DateTime.now().microsecondsSinceEpoch.toString(),
        "postId": post.postId,
        "originalAuthor": post.author,
        "sharedBy": sharedBy,
        "content": post.content,
        "quote": quote,
        "timeAgo": "Just now",
      },
    );
  }

  Map<String, dynamic> toBackendPayload(ShareModel share) {
    return {
      "shareId": share.shareId,
      "postId": share.postId,
      "originalAuthor": share.originalAuthor,
      "sharedBy": share.sharedBy,
      "content": share.content,
      "quote": share.quote,
      "timeAgo": share.timeAgo,
    };
  }

  ShareModel fromBackendPayload(Map<String, dynamic> data) {
    return ShareModel(
      shareId: data["shareId"] ?? "",
      postId: data["postId"] ?? "",
      originalAuthor: data["originalAuthor"] ?? "",
      sharedBy: data["sharedBy"] ?? "",
      content: data["content"] ?? "",
      quote: data["quote"],
      timeAgo: data["timeAgo"] ?? "",
    );
  }
}
