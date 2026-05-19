import '../models/post_model.dart';
import '../models/researcher_model.dart';
import 'post_service.dart';
import 'researcher_service.dart';

class SearchService {
  static List<PostModel> searchPosts(String query) {
    final keyword = query.trim().toLowerCase();

    if (keyword.isEmpty) return [];

    return PostService.posts.where((post) {
      final contentMatch = post.content.toLowerCase().contains(keyword);
      final authorMatch = post.author.toLowerCase().contains(keyword);
      final universityMatch = post.university.toLowerCase().contains(keyword);
      final typeMatch = post.type.toLowerCase().contains(keyword);
      final tagMatch = post.tags.any(
        (tag) => tag.toLowerCase().contains(keyword),
      );

      return contentMatch ||
          authorMatch ||
          universityMatch ||
          typeMatch ||
          tagMatch;
    }).toList();
  }

  static List<ResearcherModel> searchResearchers(String query) {
    final keyword = query.trim().toLowerCase();

    if (keyword.isEmpty) return [];

    return ResearcherService.researchers.where((researcher) {
      final nameMatch = researcher.name.toLowerCase().contains(keyword);
      final universityMatch = researcher.university.toLowerCase().contains(
        keyword,
      );
      final interestMatch = researcher.interests.any(
        (interest) => interest.toLowerCase().contains(keyword),
      );

      return nameMatch || universityMatch || interestMatch;
    }).toList();
  }
}
