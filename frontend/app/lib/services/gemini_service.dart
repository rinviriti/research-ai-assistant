import 'dart:convert';

import 'package:http/http.dart' as http;

class GeminiService {
  static const String apiKey = "PASTE_YOUR_API_KEY_HERE";

  static Future<String> generateSummary({
    required String title,
    required String abstract,
  }) async {
    try {
      final url = Uri.parse(
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey",
      );

      final prompt =
          """
Generate a professional research paper summary.

Title:
$title

Abstract:
$abstract

Provide:
1. Research Objective
2. Methodology
3. Key Findings
4. Conclusion
""";

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt},
              ],
            },
          ],
        }),
      );

      final data = jsonDecode(response.body);

      return data["candidates"][0]["content"]["parts"][0]["text"];
    } catch (e) {
      return "Failed to generate AI summary.";
    }
  }
}
