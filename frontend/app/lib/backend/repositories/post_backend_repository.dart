import '../../models/post_model.dart';
import '../../services/post_service.dart';
import '../mock_backend/mock_database.dart';

class PostBackendRepository {
  Future<List<PostModel>> getPosts() async {
    await PostService.loadPosts();
    return PostService.getPosts();
  }

  Future<List<PostModel>> getSavedPosts() async {
    await PostService.loadPosts();
    return PostService.getSavedPosts();
  }

  Future<PostModel?> getPostById(String postId) async {
    return PostService.getPostById(postId);
  }

  Future<void> createPost(PostModel post) async {
    PostService.addPost(post);

    await MockDatabase.addDocument(collection: "posts", data: post.toJson());
  }

  Future<void> setReaction({
    required String postId,
    required String reactionType,
  }) async {
    PostService.setReaction(postId: postId, reactionType: reactionType);
  }

  Future<void> toggleBookmark(String postId) async {
    PostService.toggleBookmark(postId);
  }

  Future<void> incrementCommentCount(String postId) async {
    PostService.incrementCommentCount(postId);
  }

  Future<void> clearPosts() async {
    PostService.clearPosts();

    await MockDatabase.clearCollection("posts");
  }

  Stream<List<PostModel>> watchPosts() {
    return PostService.stream;
  }

  Map<String, dynamic> toBackendPayload(PostModel post) {
    return post.toJson();
  }

  PostModel fromBackendPayload(Map<String, dynamic> data) {
    return PostModel.fromJson(data);
  }
}
