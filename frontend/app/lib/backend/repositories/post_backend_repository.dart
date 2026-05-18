import '../../models/post_model.dart';
import '../../services/post_service.dart';
import '../mock_backend/mock_database.dart';

class PostBackendRepository {
  Future<List<PostModel>> getPosts() async {
    return PostService.posts;
  }

  Future<void> createPost(PostModel post) async {
    PostService.addPost(post);

    await MockDatabase.addDocument(
      collection: "posts",
      data: toBackendPayload(post),
    );
  }

  Future<void> toggleLike(String postId) async {
    PostService.toggleLike(postId);
  }

  Map<String, dynamic> toBackendPayload(PostModel post) {
    return {
      "postId": post.postId,
      "author": post.author,
      "university": post.university,
      "content": post.content,
      "type": post.type,
      "tags": post.tags,
      "timeAgo": post.timeAgo,
      "likes": post.likes,
      "isLiked": post.isLiked,
    };
  }

  PostModel fromBackendPayload(Map<String, dynamic> data) {
    return PostModel(
      postId: data["postId"] ?? "",
      author: data["author"] ?? "",
      university: data["university"] ?? "",
      content: data["content"] ?? "",
      type: data["type"] ?? "",
      tags: List<String>.from(data["tags"] ?? []),
      timeAgo: data["timeAgo"] ?? "",
      likes: data["likes"] ?? 0,
      isLiked: data["isLiked"] ?? false,
    );
  }
}
