import '../models/researcher_model.dart';
import '../models/swipe_match_model.dart';
import 'researcher_service.dart';

class SwipeMatchService {
  static final List<SwipeMatchModel> matches = [];
  static final List<String> skippedResearchers = [];

  static final List<String> myInterests = [
    "Medical Imaging",
    "Deep Learning",
    "Brain Tumor Segmentation",
    "Flutter",
  ];

  static List<ResearcherModel> getAvailableResearchers() {
    return ResearcherService.researchers.where((researcher) {
      final alreadyMatched = matches.any(
        (match) => match.researcherName == researcher.name,
      );

      final alreadySkipped = skippedResearchers.contains(researcher.name);

      return !alreadyMatched && !alreadySkipped;
    }).toList();
  }

  static int calculateMatchScore(ResearcherModel researcher) {
    return ResearcherService.calculateMatchScore(
      myInterests,
      researcher.interests,
    );
  }

  static void likeResearcher(ResearcherModel researcher) {
    final score = calculateMatchScore(researcher);

    matches.add(
      SwipeMatchModel(
        researcherName: researcher.name,
        university: researcher.university,
        matchScore: score,
        status: "interested",
      ),
    );
  }

  static void skipResearcher(ResearcherModel researcher) {
    skippedResearchers.add(researcher.name);
  }

  static void resetSwipes() {
    matches.clear();
    skippedResearchers.clear();
  }
}
