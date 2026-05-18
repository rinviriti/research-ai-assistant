import '../../models/researcher_model.dart';
import '../../models/swipe_match_model.dart';
import '../../services/swipe_match_service.dart';
import '../mock_backend/mock_database.dart';

class MatchingBackendRepository {
  Future<List<ResearcherModel>> getAvailableResearchers() async {
    return SwipeMatchService.getAvailableResearchers();
  }

  Future<List<SwipeMatchModel>> getMatches() async {
    return SwipeMatchService.matches;
  }

  Future<void> likeResearcher(ResearcherModel researcher) async {
    SwipeMatchService.likeResearcher(researcher);

    final score = SwipeMatchService.calculateMatchScore(researcher);

    await MockDatabase.addDocument(
      collection: "matches",
      data: {
        "researcherName": researcher.name,
        "university": researcher.university,
        "matchScore": score,
        "status": "interested",
      },
    );
  }

  Future<void> skipResearcher(ResearcherModel researcher) async {
    SwipeMatchService.skipResearcher(researcher);
  }

  Future<void> resetMatches() async {
    SwipeMatchService.resetSwipes();
    await MockDatabase.clearCollection("matches");
  }

  Map<String, dynamic> matchToPayload(SwipeMatchModel match) {
    return {
      "researcherName": match.researcherName,
      "university": match.university,
      "matchScore": match.matchScore,
      "status": match.status,
    };
  }

  SwipeMatchModel matchFromPayload(Map<String, dynamic> data) {
    return SwipeMatchModel(
      researcherName: data["researcherName"] ?? "",
      university: data["university"] ?? "",
      matchScore: data["matchScore"] ?? 0,
      status: data["status"] ?? "",
    );
  }
}
