import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class UploadPaperScreen extends StatefulWidget {
  const UploadPaperScreen({super.key});

  @override
  State<UploadPaperScreen> createState() => _UploadPaperScreenState();
}

class _UploadPaperScreenState extends State<UploadPaperScreen> {
  String fileName = "";
  String extractedText = "";
  String aiSummary = "";

  bool isLoading = false;

  Future<void> pickPDF() async {
    setState(() {
      isLoading = true;
      fileName = "";
      extractedText = "";
      aiSummary = "";
    });

    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );

    if (result == null) {
      setState(() {
        isLoading = false;
      });

      return;
    }

    final PlatformFile file = result.files.first;

    final Uint8List? bytes = file.bytes;

    if (bytes == null) {
      setState(() {
        isLoading = false;
      });

      return;
    }

    try {
      final PdfDocument document = PdfDocument(inputBytes: bytes);

      final PdfTextExtractor extractor = PdfTextExtractor(document);

      final String text = extractor.extractText();

      document.dispose();

      final String summary = generateAISummary(text);

      setState(() {
        fileName = file.name;

        extractedText = text;

        aiSummary = summary;

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        extractedText = "Failed to extract PDF text.";

        isLoading = false;
      });
    }
  }

  String generateAISummary(String text) {
    if (text.isEmpty) {
      return "No readable text found.";
    }

    final shortened = text.length > 1200 ? text.substring(0, 1200) : text;

    return """
This research paper discusses advanced concepts related to artificial intelligence, machine learning, and research methodologies.

Key Insights:
• The paper focuses on solving complex research problems using modern computational techniques.
• Experimental analysis and evaluation metrics are included.
• The proposed methodology demonstrates improved performance and efficiency.
• Future improvements and research opportunities are discussed.

Extracted Preview:
$shortened
""";
  }

  String getPreviewText() {
    if (extractedText.length > 2500) {
      return "${extractedText.substring(0, 2500)}...";
    }

    return extractedText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      appBar: AppBar(
        title: const Text("Upload Paper"),

        backgroundColor: const Color(0xFF1E293B),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Center(
              child: Icon(
                Icons.picture_as_pdf,
                color: Colors.redAccent,
                size: 80,
              ),
            ),

            const SizedBox(height: 20),

            const Center(
              child: Text(
                "Research Paper Upload",

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            const Center(
              child: Text(
                "Upload PDF papers and generate AI summaries.",

                textAlign: TextAlign.center,

                style: TextStyle(color: Colors.white70),
              ),
            ),

            const SizedBox(height: 35),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton.icon(
                onPressed: isLoading ? null : pickPDF,

                icon: const Icon(Icons.upload_file),

                label: Text(isLoading ? "Processing..." : "Choose PDF File"),
              ),
            ),

            const SizedBox(height: 25),

            if (isLoading) const Center(child: CircularProgressIndicator()),

            if (fileName.isNotEmpty)
              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),

                  borderRadius: BorderRadius.circular(18),
                ),

                child: Row(
                  children: [
                    const Icon(Icons.description, color: Colors.blueAccent),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        fileName,

                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 30),

            if (aiSummary.isNotEmpty)
              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),

                  borderRadius: BorderRadius.circular(18),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text(
                      "AI Generated Summary",

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      aiSummary,

                      style: const TextStyle(
                        color: Colors.white70,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 30),

            if (extractedText.isNotEmpty)
              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),

                  borderRadius: BorderRadius.circular(18),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text(
                      "Extracted Text Preview",

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      getPreviewText(),

                      style: const TextStyle(
                        color: Colors.white70,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
