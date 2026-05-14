import 'package:flutter/material.dart';

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

    if (projectName.isEmpty || description.isEmpty) return;

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

## Tech Stack
- Flutter
- Dart
- Python/FastAPI
- AI/NLP

## Future Improvements
- Real AI API integration
- Cloud database
- User authentication
- PDF text extraction
""";
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
            ElevatedButton(
              onPressed: generateDocs,
              child: const Text("Generate README"),
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
                child: Text(
                  generatedDoc,
                  style: const TextStyle(color: Colors.white70, height: 1.5),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
