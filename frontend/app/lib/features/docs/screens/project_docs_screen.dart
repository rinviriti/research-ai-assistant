import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProjectDocsScreen extends StatefulWidget {
  const ProjectDocsScreen({super.key});

  @override
  State<ProjectDocsScreen> createState() => _ProjectDocsScreenState();
}

class _ProjectDocsScreenState extends State<ProjectDocsScreen> {
  final projectNameController = TextEditingController();
  final descriptionController = TextEditingController();

  String generatedDoc = "";

  void generateDocs() {
    final projectName = projectNameController.text.trim();
    final description = descriptionController.text.trim();

    if (projectName.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter project name and description."),
        ),
      );
      return;
    }

    setState(() {
      generatedDoc =
          """
# $projectName

## Overview
$description

## Features
- AI-powered research support
- Paper summarization
- Experiment tracking
- Project documentation generation
- Saved summary history

## Tech Stack
- Flutter
- Dart
- SharedPreferences
- Python/FastAPI planned
- AI/NLP planned

## Project Goals
This project aims to help students and researchers organize research papers, generate summaries, track experiments, and create GitHub-ready documentation.

## Future Improvements
- Real AI API integration
- PDF text extraction
- Firebase authentication
- Cloud database
- Export summaries as PDF
""";
    });
  }

  void copyDocs() {
    if (generatedDoc.isEmpty) return;

    Clipboard.setData(ClipboardData(text: generatedDoc));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("README copied to clipboard 🚀")),
    );
  }

  void clearFields() {
    projectNameController.clear();
    descriptionController.clear();

    setState(() {
      generatedDoc = "";
    });
  }

  @override
  void dispose() {
    projectNameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text("Project Docs"),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.description, color: Colors.blueAccent, size: 70),

            const SizedBox(height: 20),

            const Text(
              "README Generator",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: projectNameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Project Name",
                labelStyle: TextStyle(color: Colors.white70),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: descriptionController,
              maxLines: 5,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Project Description",
                labelStyle: TextStyle(color: Colors.white70),
              ),
            ),

            const SizedBox(height: 25),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: generateDocs,
                    child: const Text("Generate README"),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: clearFields,
                  child: const Icon(Icons.refresh),
                ),
              ],
            ),

            const SizedBox(height: 25),

            if (generatedDoc.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: copyDocs,
                        icon: const Icon(Icons.copy, color: Colors.blueAccent),
                      ),
                    ),
                    Text(
                      generatedDoc,
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
