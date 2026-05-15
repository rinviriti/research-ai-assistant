import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../models/summary_model.dart';
import '../../../services/summary_service.dart';

class SummaryDetailScreen extends StatefulWidget {
  final SummaryModel summary;

  const SummaryDetailScreen({super.key, required this.summary});

  @override
  State<SummaryDetailScreen> createState() => _SummaryDetailScreenState();
}

class _SummaryDetailScreenState extends State<SummaryDetailScreen> {
  late TextEditingController titleController;
  late TextEditingController summaryController;

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.summary.title);
    summaryController = TextEditingController(text: widget.summary.summary);
  }

  Future<void> toggleFavorite() async {
    setState(() {
      widget.summary.isFavorite = !widget.summary.isFavorite;
    });

    await SummaryService.saveToStorage();
  }

  Future<void> saveEditedSummary() async {
    final title = titleController.text.trim();
    final summaryText = summaryController.text.trim();

    if (title.isEmpty || summaryText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Title and summary cannot be empty.")),
      );
      return;
    }

    final index = SummaryService.savedSummaries.indexOf(widget.summary);

    if (index != -1) {
      SummaryService.savedSummaries[index] = SummaryModel(
        title: title,
        summary: summaryText,
        isFavorite: widget.summary.isFavorite,
      );

      await SummaryService.saveToStorage();
    }

    if (!mounted) return;

    setState(() {
      isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Summary updated successfully.")),
    );
  }

  void copySummary() {
    Clipboard.setData(
      ClipboardData(
        text:
            """
Title:
${titleController.text}

Summary:
${summaryController.text}
""",
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Summary copied to clipboard 🚀")),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    summaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayTitle = titleController.text;
    final displaySummary = summaryController.text;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text("Summary Details"),
        backgroundColor: const Color(0xFF1E293B),
        actions: [
          IconButton(
            onPressed: toggleFavorite,
            icon: Icon(
              widget.summary.isFavorite ? Icons.star : Icons.star_border,
              color: widget.summary.isFavorite ? Colors.amber : Colors.white,
            ),
          ),
          IconButton(onPressed: copySummary, icon: const Icon(Icons.copy)),
          IconButton(
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
              });
            },
            icon: Icon(isEditing ? Icons.close : Icons.edit),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(18),
          ),
          child: isEditing
              ? Column(
                  children: [
                    TextField(
                      controller: titleController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "Title",
                        labelStyle: TextStyle(color: Colors.white70),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: summaryController,
                      maxLines: 10,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "Summary",
                        labelStyle: TextStyle(color: Colors.white70),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: saveEditedSummary,
                        child: const Text("Save Changes"),
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      displaySummary,
                      style: const TextStyle(
                        color: Colors.white70,
                        height: 1.7,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
