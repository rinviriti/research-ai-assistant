import 'dart:convert';

import 'package:http/http.dart' as http;

class GeminiService {
  static const String apiKey = String.fromEnvironment(
    "AIzaSyDmOeiLC4kQRAUUaSUHsPCTjei1PdYEktI",
  );
  static Future<String> generatePdfSummary({
    required String fileName,
    required String extractedText,
  }) async {
    final limitedText = extractedText.length > 3000
        ? extractedText.substring(0, 3000)
        : extractedText;

    return generateSummary(
      title: "PDF Research Paper: $fileName",
      abstract:
          """
Summarize this uploaded research paper PDF.

Focus on:
1. Paper topic
2. Main objective
3. Methodology
4. Key contribution
5. Possible future work

PDF Text:
$limitedText
""",
    );
  }

  static Future<String> generateSummary({
    required String title,
    required String abstract,
  }) async {
    if (apiKey.isEmpty) {
      return generateFallbackSummary(title, abstract);
    }

    try {
      final response = await http.post(
        Uri.parse(
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey",
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text":
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
""",
                },
              ],
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final text = data["candidates"]?[0]?["content"]?["parts"]?[0]?["text"];

        if (text != null) {
          return text;
        }
      }

      return generateFallbackSummary(title, abstract);
    } catch (e) {
      return generateFallbackSummary(title, abstract);
    }
  }

  static String generateFallbackSummary(String title, String abstract) {
    final lowerAbstract = abstract.toLowerCase();

    String researchArea = "artificial intelligence and research automation";

    if (lowerAbstract.contains("tumor") ||
        lowerAbstract.contains("mri") ||
        lowerAbstract.contains("segmentation")) {
      researchArea = "medical image segmentation";
    } else if (lowerAbstract.contains("bronchoscopic") ||
        lowerAbstract.contains("lesion") ||
        lowerAbstract.contains("detection")) {
      researchArea = "real-time medical object detection";
    } else if (lowerAbstract.contains("embryo") ||
        lowerAbstract.contains("fertility") ||
        lowerAbstract.contains("metabolomics")) {
      researchArea = "embryo fertility prediction using multimodal learning";
    } else if (lowerAbstract.contains("dengue") ||
        lowerAbstract.contains("weather")) {
      researchArea = "disease risk prediction using machine learning";
    }

    return """
1. Research Objective
This study titled "$title" focuses on $researchArea. The main objective is to improve research or clinical decision-making through intelligent computational methods.

2. Methodology
The proposed approach uses machine learning or deep learning techniques to analyze complex data patterns. Based on the provided abstract, the method includes preprocessing, feature extraction, model development, and performance evaluation using relevant metrics.

3. Key Findings
The study suggests that intelligent AI-based methods can improve accuracy, efficiency, and reliability compared to traditional approaches. The framework appears suitable for research environments where automation, prediction, or decision support is important.

4. Conclusion
Overall, the work demonstrates the potential of AI-driven systems in $researchArea. Future improvements may include larger datasets, real-world validation, explainable AI, and deployment in practical research or clinical settings.

Note: Gemini API was unavailable or quota-limited, so this fallback summary was generated locally.
""";
  }
}
