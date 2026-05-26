import 'dart:convert';

import 'package:http/http.dart' as http;

class GeminiService {
  static const String apiKey = String.fromEnvironment("GEMINI_API_KEY");

  static Future<String> generatePdfSummary({
    required String fileName,
    required String extractedText,
  }) async {
    final limitedText = extractedText.length > 3000
        ? extractedText.substring(0, 3000)
        : extractedText;

    return generateResearchResponse(
      mode: "Paper Summary",
      userInput:
          """
Summarize this uploaded research paper PDF.

File name:
$fileName

PDF Text:
$limitedText
""",
    );
  }

  static Future<String> generateSummary({
    required String title,
    required String abstract,
  }) async {
    return generateResearchResponse(
      mode: "Paper Summary",
      userInput:
          """
Title:
$title

Abstract:
$abstract
""",
    );
  }

  static Future<String> generateResearchResponse({
    required String mode,
    required String userInput,
  }) async {
    if (apiKey.isEmpty) {
      return generateFallbackResponse(mode, userInput);
    }

    try {
      final prompt = buildPrompt(mode: mode, userInput: userInput);

      final response = await http.post(
        Uri.parse(
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey",
        ),
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

      if (response.statusCode != 200) {
        return generateFallbackResponse(mode, userInput);
      }

      final data = jsonDecode(response.body);
      final text = data["candidates"]?[0]?["content"]?["parts"]?[0]?["text"];

      return text ?? generateFallbackResponse(mode, userInput);
    } catch (_) {
      return generateFallbackResponse(mode, userInput);
    }
  }

  static String buildPrompt({required String mode, required String userInput}) {
    return """
You are RH+, a professional academic AI research assistant.

Rules:
- Only help with research, academic writing, papers, datasets, methodology, experiments, citations, publication planning, and thesis guidance.
- Give structured, clear, practical answers.
- Avoid unsupported claims.
- If citations are needed, suggest what type of sources to search for.
- Be concise but academically useful.

Mode:
$mode

User request:
$userInput

Respond with:
1. Direct Answer
2. Research Guidance
3. Practical Next Steps
4. Cautions / Limitations
""";
  }

  static String generateFallbackResponse(String mode, String userInput) {
    return """
1. Direct Answer
Gemini API is unavailable or not configured, so this local fallback response was generated.

2. Research Guidance
Your request appears related to "$mode". For a stronger research output, define the research problem, dataset, methodology, evaluation metrics, and expected contribution clearly.

3. Practical Next Steps
- Clarify your research objective.
- Identify related papers.
- Choose suitable datasets.
- Define baseline methods.
- Select evaluation metrics.
- Prepare a reproducible experiment plan.

4. Cautions / Limitations
This is a fallback response, not a live AI-generated answer.
""";
  }
}
