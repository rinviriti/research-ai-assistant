import '../../models/post_model.dart';
import '../../models/researcher_model.dart';
import '../../services/search_service.dart';

class SearchBackendRepository {
  Future<List<PostModel>> searchPosts(String query) async {
    return SearchService.searchPosts(query);
  }

  Future<List<ResearcherModel>> searchResearchers(String query) async {
    return SearchService.searchResearchers(query);
  }

  Future<Map<String, dynamic>> globalSearch(String query) async {
    final posts = SearchService.searchPosts(query);
    final researchers = SearchService.searchResearchers(query);

    return {"posts": posts, "researchers": researchers};
  }
}
