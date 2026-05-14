import 'package:flutter/material.dart';

import '../../../models/summary_model.dart';
import '../../../services/summary_service.dart';
import 'saved_summary_screen.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final titleController = TextEditingController();
  final abstractController = TextEditingController();

  String generatedSummary = "";
  bool isLoading = false;

  Future<void> generateSummary() async {
    final title = titleController.text.trim();
    final abstractText = abstractController.text.trim();

    if (title.isEmpty || abstractText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter title and abstract.")),
      );
      return;
    }

    setState(() {
      isLoading = true;
      generatedSummary = "";
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
      generatedSummary =
          "This paper titled \"$title\" presents an AI-assisted approach for research understanding and structured experimentation.";
    });
  }

  Future<void> saveSummary() async {
    if (generatedSummary.isEmpty) return;

    await SummaryService.saveSummary(
      SummaryModel(
        title: titleController.text.trim(),
        summary: generatedSummary,
      ),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Summary saved permanently 🚀")),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    abstractController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text("AI Summary"),
        backgroundColor: const Color(0xFF1E293B),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SavedSummaryScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: "Paper Title"),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: abstractController,
              maxLines: 5,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: "Abstract"),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: isLoading ? null : generateSummary,
              child: Text(isLoading ? "Generating..." : "Generate Summary"),
            ),
            const SizedBox(height: 25),
            if (generatedSummary.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        generatedSummary,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: saveSummary,
                        child: const Text("Save Summary"),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
