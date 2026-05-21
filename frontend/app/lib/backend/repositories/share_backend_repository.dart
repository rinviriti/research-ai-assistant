import '../../models/post_model.dart';
import '../../models/share_model.dart';
import '../../services/share_service.dart';
import '../mock_backend/mock_database.dart';

class ShareBackendRepository {
  Future<List<ShareModel>> getSharesForPost(String postId) async {
    await ShareService.loadShares();
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
        "postId": post.postId,
        "originalAuthor": post.author,
        "sharedBy": sharedBy,
        "content": post.content,
        "quote": quote,
        "createdAt": DateTime.now().toIso8601String(),
      },
    );
  }

  Stream<List<ShareModel>> watchShares() {
    return ShareService.stream;
  }

  Map<String, dynamic> toBackendPayload(ShareModel share) {
    return share.toJson();
  }

  ShareModel fromBackendPayload(Map<String, dynamic> data) {
    return ShareModel.fromJson(data);
  }
}
