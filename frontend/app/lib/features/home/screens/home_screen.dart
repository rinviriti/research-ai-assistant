import 'package:flutter/material.dart';

import '../../../services/auth_service.dart';
import '../../../services/summary_service.dart';

import '../../auth/screens/login_screen.dart';
import '../../paper/screens/upload_paper_screen.dart';
import '../../summary/screens/summary_screen.dart';
import '../../summary/screens/saved_summary_screen.dart';
import '../../summary/screens/favorite_summary_screen.dart';
import '../../experiment/screens/experiment_tracker_screen.dart';
import '../../docs/screens/project_docs_screen.dart';
import '../../notes/screens/research_notes_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Map<String, String>> features = const [
    {"title": "Upload Paper", "subtitle": "Extract text from PDF papers"},
    {"title": "AI Summary", "subtitle": "Generate structured summaries"},
    {"title": "Experiment Tracker", "subtitle": "Track datasets and models"},
    {"title": "Research Notes", "subtitle": "Save literature review ideas"},
    {"title": "Project Docs", "subtitle": "Generate GitHub-ready README"},
  ];

  Future<void> logout(BuildContext context) async {
    await AuthService.logout();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  void openFeature(BuildContext context, String title) {
    if (title == "Upload Paper") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UploadPaperScreen()),
      );
    }

    if (title == "AI Summary") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SummaryScreen()),
      );
    }

    if (title == "Experiment Tracker") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ExperimentTrackerScreen(),
        ),
      );
    }

    if (title == "Research Notes") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ResearchNotesScreen()),
      );
    }

    if (title == "Project Docs") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProjectDocsScreen()),
      );
    }
  }

  int get totalSummaries => SummaryService.savedSummaries.length;

  int get favoriteSummaries => SummaryService.savedSummaries
      .where((summary) => summary.isFavorite)
      .length;

  Widget statCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String count,
    required String label,
    required Widget screen,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: [
              Icon(icon, color: iconColor, size: 34),
              const SizedBox(height: 10),
              Text(
                count,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(label, style: const TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            onPressed: () => logout(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome back 👋",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              AuthService.currentUser ?? "Unknown User",
              style: const TextStyle(color: Colors.blueAccent, fontSize: 16),
            ),
            const SizedBox(height: 28),

            Row(
              children: [
                statCard(
                  context: context,
                  icon: Icons.description,
                  iconColor: Colors.blueAccent,
                  count: totalSummaries.toString(),
                  label: "Summaries",
                  screen: const SavedSummaryScreen(),
                ),
                const SizedBox(width: 16),
                statCard(
                  context: context,
                  icon: Icons.star,
                  iconColor: Colors.amber,
                  count: favoriteSummaries.toString(),
                  label: "Favorites",
                  screen: const FavoriteSummaryScreen(),
                ),
              ],
            ),

            const SizedBox(height: 28),

            Expanded(
              child: GridView.builder(
                itemCount: features.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.05,
                ),
                itemBuilder: (context, index) {
                  final feature = features[index];

                  return InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () => openFeature(context, feature["title"]!),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.auto_awesome,
                            color: Colors.blueAccent,
                            size: 34,
                          ),
                          const Spacer(),
                          Text(
                            feature["title"]!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            feature["subtitle"]!,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
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
