import 'dart:convert';

import 'package:http/http.dart' as http;

class RemoteAiService {
  static const String endpointUrl = "PASTE_YOUR_VERCEL_ENDPOINT_HERE";

  static Future<String> askResearchAI(String message) async {
    try {
      final response = await http.post(
        Uri.parse(endpointUrl),

        headers: {"Content-Type": "application/json"},

        body: jsonEncode({
          "message": message,

          "systemPrompt":
              "You are RH+, an academic AI research assistant. "
              "Help only with research-related tasks including "
              "literature reviews, methodology, datasets, experiments, "
              "academic writing, citations, publications, and research ideas.",
        }),
      );

      if (response.statusCode != 200) {
        return "AI server error: ${response.statusCode}";
      }

      final data = jsonDecode(response.body);

      return data["reply"] ??
          data["response"] ??
          data["message"] ??
          "No AI response received.";
    } catch (e) {
      return "Failed to connect to AI service.";
    }
  }
}
