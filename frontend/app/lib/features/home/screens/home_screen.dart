import 'package:flutter/material.dart';

import '../../../services/summary_service.dart';
import '../../../services/experiment_service.dart';
import '../../../services/note_service.dart';

import '../../paper/screens/upload_paper_screen.dart';
import '../../summary/screens/summary_screen.dart';
import '../../summary/screens/saved_summary_screen.dart';
import '../../summary/screens/favorite_summary_screen.dart';
import '../../experiment/screens/experiment_tracker_screen.dart';
import '../../docs/screens/project_docs_screen.dart';
import '../../notes/screens/research_notes_screen.dart';
import '../../chat/screens/ai_chat_screen.dart';
import '../../feed/screens/saved_posts_screen.dart';
import '../../connections/screens/connections_screen.dart';
import '../../recommendations/screens/ai_collaborator_recommendations_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void openScreen(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  Widget sectionTitle(String title, {String? subtitle}) {
    return Column(
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
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white60, height: 1.4),
          ),
        ],
      ],
    );
  }

  Widget heroCard(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(
          colors: [primary.withOpacity(0.24), Theme.of(context).cardColor],
        ),
        border: Border.all(color: Colors.white10),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Welcome back 👋",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Text(
            "Manage your research tools, saved content, papers, notes, experiments, and academic workflow from one clean dashboard.",
            style: TextStyle(color: Colors.white70, height: 1.55, fontSize: 15),
          ),
        ],
      ),
    );
  }

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
        borderRadius: BorderRadius.circular(22),
        onTap: () => openScreen(context, screen),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(height: 18),
              Text(
                count,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.trending_up, color: iconColor, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    count == "0" ? "No activity yet" : "Active",
                    style: TextStyle(
                      color: iconColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget toolCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Widget screen,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => openScreen(context, screen),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 13,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget recentActivityItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required Widget screen,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => openScreen(context, screen),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.14),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: iconColor, size: 25),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white60, fontSize: 13),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white30,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildRecentActivities(BuildContext context) {
    final activities = <Widget>[];
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;

    if (SummaryService.savedSummaries.isNotEmpty) {
      final latest = SummaryService.savedSummaries.last;

      activities.add(
        recentActivityItem(
          context: context,
          icon: Icons.description_outlined,
          iconColor: primary,
          title: "Latest Summary",
          subtitle: latest.title,
          screen: const SavedSummaryScreen(),
        ),
      );
    }

    if (ExperimentService.experiments.isNotEmpty) {
      final latest = ExperimentService.experiments.last;

      activities.add(
        recentActivityItem(
          context: context,
          icon: Icons.science_outlined,
          iconColor: Colors.greenAccent,
          title: "Latest Experiment",
          subtitle: latest.experimentName,
          screen: const ExperimentTrackerScreen(),
        ),
      );
    }

    if (NoteService.notes.isNotEmpty) {
      final latest = NoteService.notes.last;

      activities.add(
        recentActivityItem(
          context: context,
          icon: Icons.note_alt_outlined,
          iconColor: secondary,
          title: "Latest Note",
          subtitle: latest.title,
          screen: const ResearchNotesScreen(),
        ),
      );
    }

    if (activities.isEmpty) {
      activities.add(
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white10),
          ),
          child: const Row(
            children: [
              Icon(Icons.history, color: Colors.white38),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  "No recent activity yet. Start by uploading a paper, saving a post, or writing a research note.",
                  style: TextStyle(color: Colors.white60, height: 1.4),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return activities;
  }

  @override
  Widget build(BuildContext context) {
    final totalSummaries = SummaryService.savedSummaries.length;
    final favoriteSummaries = SummaryService.savedSummaries
        .where((summary) => summary.isFavorite)
        .length;
    final totalExperiments = ExperimentService.experiments.length;
    final totalNotes = NoteService.notes.length;

    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heroCard(context),
            const SizedBox(height: 28),

            sectionTitle(
              "Research Overview",
              subtitle: "Your saved research activity at a glance.",
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                statCard(
                  context: context,
                  icon: Icons.description_outlined,
                  iconColor: primary,
                  count: totalSummaries.toString(),
                  label: "Summaries",
                  screen: const SavedSummaryScreen(),
                ),
                const SizedBox(width: 12),
                statCard(
                  context: context,
                  icon: Icons.star_outline,
                  iconColor: Colors.amber,
                  count: favoriteSummaries.toString(),
                  label: "Favorites",
                  screen: const FavoriteSummaryScreen(),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                statCard(
                  context: context,
                  icon: Icons.science_outlined,
                  iconColor: Colors.greenAccent,
                  count: totalExperiments.toString(),
                  label: "Experiments",
                  screen: const ExperimentTrackerScreen(),
                ),
                const SizedBox(width: 12),
                statCard(
                  context: context,
                  icon: Icons.note_alt_outlined,
                  iconColor: secondary,
                  count: totalNotes.toString(),
                  label: "Notes",
                  screen: const ResearchNotesScreen(),
                ),
              ],
            ),

            const SizedBox(height: 28),

            sectionTitle(
              "Research Tools",
              subtitle:
                  "Secondary tools for papers, saved work, and research productivity.",
            ),
            const SizedBox(height: 16),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.03,
              children: [
                toolCard(
                  context: context,
                  icon: Icons.picture_as_pdf_outlined,
                  title: "Upload Paper",
                  subtitle: "Extract text from PDF papers.",
                  color: Colors.redAccent,
                  screen: const UploadPaperScreen(),
                ),
                toolCard(
                  context: context,
                  icon: Icons.bookmark_border,
                  title: "Saved Posts",
                  subtitle: "Your research reading library.",
                  color: Colors.amber,
                  screen: const SavedPostsScreen(),
                ),
                toolCard(
                  context: context,
                  icon: Icons.handshake_outlined,
                  title: "Connections",
                  subtitle: "Manage your research network.",
                  color: Colors.lightGreenAccent,
                  screen: const ConnectionsScreen(),
                ),
                toolCard(
                  context: context,
                  icon: Icons.chat_bubble_outline,
                  title: "AI Chat",
                  subtitle: "Ask research questions.",
                  color: Colors.tealAccent,
                  screen: const AIChatScreen(),
                ),
                toolCard(
                  context: context,
                  icon: Icons.auto_awesome,
                  title: "AI Summary",
                  subtitle: "Generate structured summaries.",
                  color: primary,
                  screen: const SummaryScreen(),
                ),
                toolCard(
                  context: context,
                  icon: Icons.science_outlined,
                  title: "Experiment Tracker",
                  subtitle: "Track datasets and models.",
                  color: Colors.greenAccent,
                  screen: const ExperimentTrackerScreen(),
                ),
                toolCard(
                  context: context,
                  icon: Icons.auto_awesome_mosaic_outlined,
                  title: "AI Collaborators",
                  subtitle: "Find smart research matches.",
                  color: Colors.cyanAccent,
                  screen: const AiCollaboratorRecommendationsScreen(),
                ),
                toolCard(
                  context: context,
                  icon: Icons.note_alt_outlined,
                  title: "Research Notes",
                  subtitle: "Save literature review ideas.",
                  color: Colors.purpleAccent,
                  screen: const ResearchNotesScreen(),
                ),
                toolCard(
                  context: context,
                  icon: Icons.description_outlined,
                  title: "Project Docs",
                  subtitle: "Generate GitHub-ready README.",
                  color: Colors.orangeAccent,
                  screen: const ProjectDocsScreen(),
                ),
              ],
            ),

            const SizedBox(height: 28),

            sectionTitle("Recent Activity"),
            const SizedBox(height: 16),
            ...buildRecentActivities(context),
          ],
        ),
      ),
    );
  }
}
