import '../models/post_model.dart';
import '../models/researcher_model.dart';
import 'post_service.dart';
import 'researcher_service.dart';

class SearchService {
  static String normalize(String value) {
    return value.trim().toLowerCase();
  }

  static bool containsKeyword(String value, String keyword) {
    return normalize(value).contains(keyword);
  }

  static List<PostModel> searchPosts(String query) {
    final keyword = normalize(query);

    if (keyword.isEmpty) return [];

    final results = PostService.getPosts().where((post) {
      final contentMatch = containsKeyword(post.content, keyword);
      final authorMatch = containsKeyword(post.author, keyword);
      final universityMatch = containsKeyword(post.university, keyword);
      final typeMatch = containsKeyword(post.type, keyword);

      final tagMatch = post.tags.any((tag) => containsKeyword(tag, keyword));

      final mediaMatch = post.media.any(
        (media) => containsKeyword(media.fileName, keyword),
      );

      return contentMatch ||
          authorMatch ||
          universityMatch ||
          typeMatch ||
          tagMatch ||
          mediaMatch;
    }).toList();

    results.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return results;
  }

  static List<ResearcherModel> searchResearchers(String query) {
    final keyword = normalize(query);

    if (keyword.isEmpty) return [];

    return ResearcherService.researchers.where((researcher) {
      final nameMatch = containsKeyword(researcher.name, keyword);
      final universityMatch = containsKeyword(researcher.university, keyword);
      final departmentMatch = containsKeyword(researcher.department, keyword);
      final bioMatch = containsKeyword(researcher.bio, keyword);
      final lookingForMatch = containsKeyword(researcher.lookingFor, keyword);

      final interestMatch = researcher.interests.any(
        (interest) => containsKeyword(interest, keyword),
      );

      final skillMatch = researcher.skills.any(
        (skill) => containsKeyword(skill, keyword),
      );

      return nameMatch ||
          universityMatch ||
          departmentMatch ||
          bioMatch ||
          lookingForMatch ||
          interestMatch ||
          skillMatch;
    }).toList();
  }

  static bool hasResults(String query) {
    return searchPosts(query).isNotEmpty || searchResearchers(query).isNotEmpty;
  }
}
