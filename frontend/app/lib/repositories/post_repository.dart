import '../models/post_model.dart';
import '../services/post_service.dart';

class PostRepository {
  Future<List<PostModel>> getPosts() async {
    return PostService.posts;
  }

  Future<void> createPost(PostModel post) async {
    PostService.posts.insert(0, post);
  }
}
