import 'researcher_model.dart';

class CollaboratorRecommendationModel {
  final ResearcherModel researcher;
  final int score;
  final List<String> sharedInterests;
  final List<String> sharedSkills;
  final String reason;
  final String recommendedAction;

  CollaboratorRecommendationModel({
    required this.researcher,
    required this.score,
    required this.sharedInterests,
    required this.sharedSkills,
    required this.reason,
    required this.recommendedAction,
  });
}
