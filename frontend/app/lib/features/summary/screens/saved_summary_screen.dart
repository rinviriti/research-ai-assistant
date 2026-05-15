import 'package:flutter/material.dart';

import '../../../models/summary_model.dart';
import '../../../services/summary_service.dart';

import 'summary_detail_screen.dart';

class SavedSummaryScreen extends StatefulWidget {
  const SavedSummaryScreen({super.key});

  @override
  State<SavedSummaryScreen> createState() => _SavedSummaryScreenState();
}

class _SavedSummaryScreenState extends State<SavedSummaryScreen> {
  final searchController = TextEditingController();
  String searchQuery = "";

  List<SummaryModel> get filteredSummaries {
    if (searchQuery.isEmpty) return SummaryService.savedSummaries;

    return SummaryService.savedSummaries.where((summary) {
      final query = searchQuery.toLowerCase();
      return summary.title.toLowerCase().contains(query) ||
          summary.summary.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> deleteSummary(int index) async {
    final originalIndex = SummaryService.savedSummaries.indexOf(
      filteredSummaries[index],
    );

    await SummaryService.deleteSummary(originalIndex);
    setState(() {});
  }

  Widget emptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_border, color: Colors.blueAccent, size: 80),
          SizedBox(height: 18),
          Text(
            "No summaries yet",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Generate or upload a paper summary to save it here.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, height: 1.5),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final summaries = filteredSummaries;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text("Saved Summaries"),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search summaries...",
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),

            const SizedBox(height: 24),

            Expanded(
              child: summaries.isEmpty
                  ? emptyState()
                  : ListView.builder(
                      itemCount: summaries.length,
                      itemBuilder: (context, index) {
                        final summary = summaries[index];

                        return InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SummaryDetailScreen(summary: summary),
                              ),
                            );
                          },
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
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.redAccent,
                                      ),
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
            ),
          ],
        ),
      ),
    );
  }
}
