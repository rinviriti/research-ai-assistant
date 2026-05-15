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

  bool isLoading = false;

  Future<void> pickPDF() async {
    setState(() {
      isLoading = true;
    });

    final result = await FilePicker.platform.pickFiles(
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

    final file = result.files.first;

    fileName = file.name;

    final Uint8List? bytes = file.bytes;

    if (bytes == null) {
      setState(() {
        isLoading = false;
      });

      return;
    }

    try {
      final PdfDocument document = PdfDocument(inputBytes: bytes);

      String text = "";

      for (int i = 0; i < document.pages.count; i++) {
        text += PdfTextExtractor(
          document,
        ).extractText(startPageIndex: i, endPageIndex: i);
      }

      document.dispose();

      setState(() {
        extractedText = text;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        extractedText = "Failed to extract PDF text.";
        isLoading = false;
      });
    }
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
                "Upload PDF papers and extract text content.",

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

            if (isLoading) const Center(child: CircularProgressIndicator()),

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
                      "Extracted Text",

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      extractedText.length > 3000
                          ? extractedText.substring(0, 3000) + "..."
                          : extractedText,

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
