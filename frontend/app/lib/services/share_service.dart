import 'dart:async';

import '../models/post_model.dart';
import '../models/share_model.dart';
import 'local_storage_service.dart';
import 'notification_service.dart';
import 'post_service.dart';
import 'session_service.dart';

class ShareService {
  static final List<ShareModel> shares = [];

  static final StreamController<List<ShareModel>> _controller =
      StreamController<List<ShareModel>>.broadcast();

  static const String storageKey = "rh_shares";

  static Stream<List<ShareModel>> get stream {
    Future.microtask(sync);
    return _controller.stream;
  }

  static void sync() {
    if (!_controller.isClosed) {
      _controller.add(List<ShareModel>.from(shares));
    }

    saveShares();
  }

  static Future<void> loadShares() async {
    final data = await LocalStorageService.getJson(storageKey);

    if (data == null) return;

    shares.clear();

    shares.addAll(
      (data as List)
          .map((item) => ShareModel.fromJson(Map<String, dynamic>.from(item)))
          .toList(),
    );

    shares.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    sync();
  }

  static Future<void> saveShares() async {
    await LocalStorageService.saveJson(
      key: storageKey,
      data: shares.map((share) => share.toJson()).toList(),
    );
  }

  static List<ShareModel> getSharesForPost(String postId) {
    final postShares = shares.where((share) => share.postId == postId).toList();

    postShares.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return postShares;
  }

  static int shareCount(String postId) {
    return shares.where((share) => share.postId == postId).length;
  }

  static void sharePost({
    required PostModel post,
    required String sharedBy,
    String? quote,
  }) {
    final now = DateTime.now();

    final share = ShareModel(
      shareId: now.microsecondsSinceEpoch.toString(),
      postId: post.postId,
      originalAuthor: post.author,
      sharedBy: sharedBy,
      content: post.content,
      quote: quote,
      createdAt: now,
    );

    shares.insert(0, share);

    final repost = PostModel(
      postId: "share_${share.shareId}",
      authorId: SessionService.currentUser?.userId ?? "local_user",
      author: sharedBy,
      university: "Your University",
      content: quote == null || quote.trim().isEmpty
          ? "Shared ${post.author}'s research post:\n\n${post.content}"
          : "$quote\n\nShared ${post.author}'s research post:\n\n${post.content}",
      type: "Shared Research",
      tags: post.tags,
      createdAt: now,
      likes: 0,
      media: post.media,
    );

    PostService.addPost(repost);

    NotificationService.addNotification(
      title: "Research Post Shared",
      body: "$sharedBy shared ${post.author}'s research post.",
      type: "post",
      targetId: post.postId,
      targetName: post.author,
      payload: {
        "postId": post.postId,
        "sharedBy": sharedBy,
        "originalAuthor": post.author,
      },
    );

    sync();
  }

  static void clearShares() {
    shares.clear();
    sync();
  }
}
