import 'dart:async';

import '../models/post_model.dart';
import '../models/saved_post_model.dart';
import 'local_storage_service.dart';
import 'notification_service.dart';

class SavedPostService {
  static final List<SavedPostModel> savedPosts = [];

  static final StreamController<List<SavedPostModel>> _controller =
      StreamController<List<SavedPostModel>>.broadcast();

  static const String storageKey = "rh_saved_posts";

  static Stream<List<SavedPostModel>> get stream {
    Future.microtask(sync);
    return _controller.stream;
  }

  static void sync() {
    if (!_controller.isClosed) {
      _controller.add(List<SavedPostModel>.from(savedPosts));
    }

    saveSavedPosts();
  }

  static Future<void> loadSavedPosts() async {
    final data = await LocalStorageService.getJson(storageKey);

    if (data == null) return;

    savedPosts.clear();

    savedPosts.addAll(
      (data as List)
          .map(
            (item) => SavedPostModel.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList(),
    );

    savedPosts.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    sync();
  }

  static Future<void> saveSavedPosts() async {
    await LocalStorageService.saveJson(
      key: storageKey,
      data: savedPosts.map((item) => item.toJson()).toList(),
    );
  }

  static bool isSaved(String postId) {
    return savedPosts.any((savedPost) => savedPost.postId == postId);
  }

  static List<SavedPostModel> getSavedPosts() {
    savedPosts.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return List<SavedPostModel>.from(savedPosts);
  }

  static void savePost({required PostModel post, required String savedBy}) {
    if (isSaved(post.postId)) return;

    savedPosts.insert(
      0,
      SavedPostModel(
        savedId: DateTime.now().microsecondsSinceEpoch.toString(),
        postId: post.postId,
        postAuthor: post.author,
        postContent: post.content,
        savedBy: savedBy,
        createdAt: DateTime.now(),
      ),
    );

    NotificationService.addNotification(
      title: "Research Post Saved",
      body: "You saved a research post by ${post.author}.",
      type: "post",
      targetId: post.postId,
      targetName: post.author,
      payload: {"postId": post.postId},
    );

    sync();
  }

  static void unsavePost(String postId) {
    savedPosts.removeWhere((savedPost) => savedPost.postId == postId);

    sync();
  }

  static void toggleSave({required PostModel post, required String savedBy}) {
    if (isSaved(post.postId)) {
      unsavePost(post.postId);
    } else {
      savePost(post: post, savedBy: savedBy);
    }
  }

  static void clearSavedPosts() {
    savedPosts.clear();
    sync();
  }
}
