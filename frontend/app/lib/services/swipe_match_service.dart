import 'dart:async';

import '../models/researcher_model.dart';
import '../models/swipe_match_model.dart';
import 'notification_service.dart';
import 'research_profile_service.dart';
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
    final profile = ResearchProfileService.currentProfile;

    if (profile == null) return 0;

    return ResearcherService.calculateMatchScore(
      profile.researchInterests,
      researcher.interests,
      mySkills: profile.skills,
      otherSkills: researcher.skills,
    );
  }

  static void refreshScores() {
    final updatedMatches = matches.map((match) {
      final researcher = ResearcherService.researchers.firstWhere(
        (item) => item.name == match.researcherName,
        orElse: () => ResearcherModel(
          name: match.researcherName,
          university: match.university,
          department: "",
          bio: "",
          interests: [],
          skills: [],
          lookingFor: "",
        ),
      );

      return SwipeMatchModel(
        researcherName: match.researcherName,
        university: match.university,
        matchScore: calculateMatchScore(researcher),
        status: match.status,
      );
    }).toList();

    matches
      ..clear()
      ..addAll(updatedMatches);

    syncMatches();
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
