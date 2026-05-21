import 'dart:async';

import '../models/researcher_model.dart';
import '../models/swipe_match_model.dart';
import 'notification_service.dart';
import 'researcher_service.dart';

class SwipeMatchService {
  static final List<SwipeMatchModel> matches = [];
  static final List<String> skippedResearchers = [];

  static final StreamController<List<SwipeMatchModel>> _matchController =
      StreamController<List<SwipeMatchModel>>.broadcast();

  static Stream<List<SwipeMatchModel>> get matchStream {
    Future.microtask(syncMatches);
    return _matchController.stream;
  }

  static void syncMatches() {
    if (!_matchController.isClosed) {
      _matchController.add(List<SwipeMatchModel>.from(matches));
    }
  }

  static List<SwipeMatchModel> getMatches() {
    return List<SwipeMatchModel>.from(matches);
  }

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

    final alreadyMatched = matches.any(
      (match) => match.researcherName == researcher.name,
    );

    if (alreadyMatched) return;

    matches.insert(
      0,
      SwipeMatchModel(
        researcherName: researcher.name,
        university: researcher.university,
        matchScore: score,
        status: "interested",
      ),
    );

    NotificationService.addNotification(
      title: "New Research Match",
      body:
          "You showed interest in ${researcher.name} from ${researcher.university}.",
      type: "match",
      targetName: researcher.name,
      payload: {
        "researcherName": researcher.name,
        "university": researcher.university,
        "interests": researcher.interests,
      },
    );

    syncMatches();
  }

  static void skipResearcher(ResearcherModel researcher) {
    if (!skippedResearchers.contains(researcher.name)) {
      skippedResearchers.add(researcher.name);
    }

    syncMatches();
  }

  static void resetSwipes() {
    matches.clear();
    skippedResearchers.clear();

    NotificationService.addNotification(
      title: "Swipe Matching Reset",
      body: "Your research swipe matching activity has been reset.",
      type: "match",
      payload: {
        "researcherName": "Researcher",
        "university": "Research Network",
        "interests": <String>[],
      },
    );

    syncMatches();
  }
}
