import 'package:flutter/material.dart';

class AboutProjectScreen extends StatelessWidget {
  const AboutProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text("About Project"),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Icon(Icons.auto_awesome, color: Colors.blueAccent, size: 80),
          const SizedBox(height: 20),
          const Text(
            "Research AI Assistant",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "A Flutter-based research productivity app for summarizing papers, saving notes, tracking experiments, extracting PDF text, and generating GitHub-ready documentation.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, height: 1.5, fontSize: 16),
          ),
          const SizedBox(height: 30),
          _section(
            title: "Tech Stack",
            items: [
              "Flutter & Dart",
              "SharedPreferences",
              "PDF Text Extraction",
              "Local Authentication",
              "Research Workflow Tools",
            ],
          ),
          const SizedBox(height: 24),
          _section(
            title: "Key Features",
            items: [
              "Login and signup flow",
              "PDF upload and text extraction",
              "AI-style summary generation",
              "Saved summaries with favorites",
              "Experiment tracker",
              "Research notes",
              "README generator",
              "Profile image upload",
            ],
          ),
        ],
      ),
    );
  }

  Widget _section({required String title, required List<String> items}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                "• $item",
                style: const TextStyle(color: Colors.white70, height: 1.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
