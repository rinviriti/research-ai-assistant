import '../../models/post_model.dart';
import '../../models/saved_post_model.dart';
import '../../services/saved_post_service.dart';
import '../mock_backend/mock_database.dart';

class SavedPostBackendRepository {
  Future<List<SavedPostModel>> getSavedPosts() async {
    return SavedPostService.savedPosts;
  }

  Future<bool> isSaved(String postId) async {
    return SavedPostService.isSaved(postId);
  }

  Future<void> toggleSave({
    required PostModel post,
    required String savedBy,
  }) async {
    SavedPostService.toggleSave(post: post, savedBy: savedBy);

    await MockDatabase.addDocument(
      collection: "savedPosts",
      data: {
        "savedId": DateTime.now().microsecondsSinceEpoch.toString(),
        "postId": post.postId,
        "postAuthor": post.author,
        "postContent": post.content,
        "savedBy": savedBy,
        "timeAgo": "Just now",
      },
    );
  }

  Future<void> unsavePost(String postId) async {
    SavedPostService.unsavePost(postId);
  }

  Map<String, dynamic> toBackendPayload(SavedPostModel savedPost) {
    return {
      "savedId": savedPost.savedId,
      "postId": savedPost.postId,
      "postAuthor": savedPost.postAuthor,
      "postContent": savedPost.postContent,
      "savedBy": savedPost.savedBy,
      "timeAgo": savedPost.timeAgo,
    };
  }

  SavedPostModel fromBackendPayload(Map<String, dynamic> data) {
    return SavedPostModel(
      savedId: data["savedId"] ?? "",
      postId: data["postId"] ?? "",
      postAuthor: data["postAuthor"] ?? "",
      postContent: data["postContent"] ?? "",
      savedBy: data["savedBy"] ?? "",
      timeAgo: data["timeAgo"] ?? "",
    );
  }
}
