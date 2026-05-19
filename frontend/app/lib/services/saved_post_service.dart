import '../models/post_model.dart';
import '../models/saved_post_model.dart';
import 'notification_service.dart';

class SavedPostService {
  static final List<SavedPostModel> savedPosts = [];

  static bool isSaved(String postId) {
    return savedPosts.any((savedPost) => savedPost.postId == postId);
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
        timeAgo: "Just now",
      ),
    );

    NotificationService.addNotification(
      title: "Research Post Saved",
      body: "You saved a research post by ${post.author}.",
      type: "post",
      targetId: post.postId,
      targetName: post.author,
    );
  }

  static void unsavePost(String postId) {
    savedPosts.removeWhere((savedPost) => savedPost.postId == postId);
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
  }
}
