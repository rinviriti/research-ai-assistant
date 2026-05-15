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
  Future<void> toggleFavorite() async {
    setState(() {
      widget.summary.isFavorite = !widget.summary.isFavorite;
    });

    await SummaryService.saveToStorage();
  }

  void copySummary() {
    Clipboard.setData(
      ClipboardData(
        text:
            """
Title:
${widget.summary.title}

Summary:
${widget.summary.summary}
""",
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Summary copied to clipboard 🚀")),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.summary.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.summary.summary,
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
