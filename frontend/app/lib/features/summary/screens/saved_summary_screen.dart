import 'package:flutter/material.dart';
import '../../../services/summary_service.dart';
import 'summary_detail_screen.dart';

class SavedSummaryScreen extends StatefulWidget {
  const SavedSummaryScreen({super.key});

  @override
  State<SavedSummaryScreen> createState() => _SavedSummaryScreenState();
}

class _SavedSummaryScreenState extends State<SavedSummaryScreen> {
  void deleteSummary(int index) {
    SummaryService.deleteSummary(index);
    setState(() {});
  }

  void openDetails(int index) {
    final summary = SummaryService.savedSummaries[index];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SummaryDetailScreen(summary: summary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final summaries = SummaryService.savedSummaries;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text("Saved Summaries"),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: summaries.isEmpty
          ? const Center(
              child: Text(
                "No summaries saved.",
                style: TextStyle(color: Colors.white70),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: summaries.length,
              itemBuilder: (context, index) {
                final summary = summaries[index];

                return InkWell(
                  onTap: () => openDetails(index),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                summary.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => deleteSummary(index),
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          summary.summary,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
