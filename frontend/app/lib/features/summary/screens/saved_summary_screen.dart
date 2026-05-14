import 'package:flutter/material.dart';
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

  void deleteSummary(int index) {
    final originalIndex = SummaryService.savedSummaries.indexOf(
      filteredSummaries[index],
    );

    SummaryService.deleteSummary(originalIndex);

    setState(() {});
  }

  void openDetails(int index) {
    final summary = filteredSummaries[index];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SummaryDetailScreen(summary: summary),
      ),
    );
  }

  void toggleFavorite(int index) {
    setState(() {
      filteredSummaries[index].isFavorite =
          !filteredSummaries[index].isFavorite;
    });
  }

  List get filteredSummaries {
    final summaries = SummaryService.savedSummaries;

    if (searchQuery.isEmpty) {
      return summaries;
    }

    return summaries.where((summary) {
      final title = summary.title.toLowerCase();

      final text = summary.summary.toLowerCase();

      final query = searchQuery.toLowerCase();

      return title.contains(query) || text.contains(query);
    }).toList();
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

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),

            child: TextField(
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
          ),

          Expanded(
            child: summaries.isEmpty
                ? const Center(
                    child: Text(
                      "No matching summaries found.",

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
                                    onPressed: () => toggleFavorite(index),

                                    icon: Icon(
                                      summary.isFavorite
                                          ? Icons.star
                                          : Icons.star_border,

                                      color: Colors.amber,
                                    ),
                                  ),

                                  IconButton(
                                    onPressed: () => deleteSummary(index),

                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
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
    );
  }
}
