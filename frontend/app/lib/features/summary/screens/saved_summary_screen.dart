import 'package:flutter/material.dart';
import '../../../services/summary_service.dart';

class SavedSummaryScreen extends StatelessWidget {
  const SavedSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      appBar: AppBar(
        title: const Text("Saved Summaries"),

        backgroundColor: const Color(0xFF1E293B),
      ),

      body: SummaryService.savedSummaries.isEmpty
          ? const Center(
              child: Text(
                "No saved summaries yet.",
                style: TextStyle(color: Colors.white70),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),

              itemCount: SummaryService.savedSummaries.length,

              itemBuilder: (context, index) {
                final summary = SummaryService.savedSummaries[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),

                  padding: const EdgeInsets.all(18),

                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),

                    borderRadius: BorderRadius.circular(18),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        summary.title,

                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        summary.summary,

                        style: const TextStyle(
                          color: Colors.white70,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
