import '../core/config/app_environment.dart';

class AiService {
  static bool get isEnabled => AppEnvironment.enableAiRecommendations;

  static Future<String> generateResearchSummary(String input) async {
    if (!isEnabled) {
      return "AI features are currently disabled.";
    }

    if (input.trim().isEmpty) {
      return "Please provide research text to summarize.";
    }

    // Placeholder for future OpenAI/Gemini API call.
    return "AI summary will be generated here after connecting a real AI provider.";
  }

  static Future<String> explainMatchReason({
    required String researcherName,
    required List<String> sharedInterests,
    required List<String> sharedSkills,
  }) async {
    if (sharedInterests.isEmpty && sharedSkills.isEmpty) {
      return "$researcherName may still be useful for broader academic networking.";
    }

    final interests = sharedInterests.join(", ");
    final skills = sharedSkills.join(", ");

    return "$researcherName is recommended because of overlap in ${interests.isEmpty ? "research direction" : interests}${skills.isEmpty ? "." : " and skills such as $skills."}";
  }
}
