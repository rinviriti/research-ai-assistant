import '../../models/post_model.dart';
import '../../models/saved_post_model.dart';
import '../../services/saved_post_service.dart';
import '../mock_backend/mock_database.dart';

class SavedPostBackendRepository {
  Future<List<SavedPostModel>> getSavedPosts() async {
    await SavedPostService.loadSavedPosts();
    return SavedPostService.getSavedPosts();
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
        "postId": post.postId,
        "postAuthor": post.author,
        "postContent": post.content,
        "savedBy": savedBy,
        "createdAt": DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> unsavePost(String postId) async {
    SavedPostService.unsavePost(postId);
  }

  Stream<List<SavedPostModel>> watchSavedPosts() {
    return SavedPostService.stream;
  }

  Map<String, dynamic> toBackendPayload(SavedPostModel savedPost) {
    return savedPost.toJson();
  }

  SavedPostModel fromBackendPayload(Map<String, dynamic> data) {
    return SavedPostModel.fromJson(data);
  }
}
