import '../models/collaborator_recommendation_model.dart';
import '../models/research_profile_model.dart';
import '../models/researcher_model.dart';

class AiRecommendationService {
  static List<CollaboratorRecommendationModel> generateRecommendations({
    required ResearchProfileModel profile,
    required List<ResearcherModel> researchers,
  }) {
    final recommendations = <CollaboratorRecommendationModel>[];

    for (final researcher in researchers) {
      final sharedInterests = _sharedItems(
        profile.researchInterests,
        researcher.interests,
      );

      final sharedSkills = _sharedItems(profile.skills, researcher.skills);

      final score = _calculateScore(
        sharedInterests: sharedInterests.length,
        totalResearcherInterests: researcher.interests.length,
        sharedSkills: sharedSkills.length,
        totalResearcherSkills: researcher.skills.length,
        profileCompletion: profile.completionPercentage,
      );

      recommendations.add(
        CollaboratorRecommendationModel(
          researcher: researcher,
          score: score,
          sharedInterests: sharedInterests,
          sharedSkills: sharedSkills,
          reason: buildReason(sharedInterests, sharedSkills),
          recommendedAction: recommendedAction(score),
        ),
      );
    }

    recommendations.sort((a, b) => b.score.compareTo(a.score));

    return recommendations;
  }

  static List<String> _sharedItems(List<String> first, List<String> second) {
    final firstSet = first.map((e) => e.toLowerCase()).toSet();

    return second
        .where((item) => firstSet.contains(item.toLowerCase()))
        .toList();
  }

  static int _calculateScore({
    required int sharedInterests,
    required int totalResearcherInterests,
    required int sharedSkills,
    required int totalResearcherSkills,
    required double profileCompletion,
  }) {
    double interestWeight = 70;
    double skillWeight = 20;
    double profileWeight = 10;

    double interestScore = totalResearcherInterests == 0
        ? 0
        : (sharedInterests / totalResearcherInterests) * interestWeight;

    double skillScore = totalResearcherSkills == 0
        ? 0
        : (sharedSkills / totalResearcherSkills) * skillWeight;

    double profileScore = (profileCompletion / 100) * profileWeight;

    final total = interestScore + skillScore + profileScore;

    return total.clamp(0, 100).round();
  }

  static String buildReason(List<String> interests, List<String> skills) {
    if (interests.isEmpty && skills.isEmpty) {
      return "Potential interdisciplinary collaboration opportunity.";
    }

    final interestText = interests.isEmpty
        ? ""
        : "shared interests in ${interests.join(", ")}";

    final skillText = skills.isEmpty
        ? ""
        : "shared skills in ${skills.join(", ")}";

    if (interestText.isNotEmpty && skillText.isNotEmpty) {
      return "Strong overlap with $interestText and $skillText.";
    }

    return "Strong overlap with ${interestText.isNotEmpty ? interestText : skillText}.";
  }

  static String recommendedAction(int score) {
    if (score >= 85) {
      return "Excellent collaboration potential. Reach out immediately.";
    }

    if (score >= 70) {
      return "Strong research alignment. Recommended for collaboration.";
    }

    if (score >= 50) {
      return "Moderate overlap. Good networking opportunity.";
    }

    return "Low overlap. Consider only for general networking.";
  }
}
