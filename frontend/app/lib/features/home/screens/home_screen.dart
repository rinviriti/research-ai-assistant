import 'package:flutter/material.dart';

import '../../../services/auth_service.dart';
import '../../../services/summary_service.dart';
import '../../../services/experiment_service.dart';
import '../../../services/note_service.dart';
import '../../../services/notification_service.dart';

import '../../auth/screens/login_screen.dart';
import '../../paper/screens/upload_paper_screen.dart';
import '../../summary/screens/summary_screen.dart';
import '../../summary/screens/saved_summary_screen.dart';
import '../../summary/screens/favorite_summary_screen.dart';
import '../../experiment/screens/experiment_tracker_screen.dart';
import '../../docs/screens/project_docs_screen.dart';
import '../../notes/screens/research_notes_screen.dart';
import '../../chat/screens/ai_chat_screen.dart';
import '../../researchers/screens/researcher_screen.dart';
import '../../feed/screens/research_feed_screen.dart';
import '../../research_profile/screens/research_profile_screen.dart';
import '../../connections/screens/connections_screen.dart';
import '../../matching/screens/swipe_matching_screen.dart';
import '../../matching/screens/research_matches_screen.dart';
import '../../messaging/screens/research_messages_screen.dart';
import '../../notifications/screens/notifications_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Map<String, String>> features = const [
    {"title": "Notifications", "subtitle": "Research activity alerts"},
    {"title": "Swipe Match", "subtitle": "Discover research collaborators"},
    {"title": "Research Matches", "subtitle": "View interested researchers"},
    {"title": "Research Messages", "subtitle": "Chat with matched researchers"},
    {"title": "Research Profile", "subtitle": "Professional academic identity"},
    {"title": "Connections", "subtitle": "Manage research network"},
    {"title": "Research Feed", "subtitle": "Share research updates"},
    {"title": "Find Researchers", "subtitle": "Match with collaborators"},
    {"title": "AI Chat", "subtitle": "Ask research questions"},
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

  void openScreen(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  void openFeature(BuildContext context, String title) {
    if (title == "Notifications") {
      openScreen(context, const NotificationsScreen());
    }

    if (title == "Swipe Match") {
      openScreen(context, const SwipeMatchingScreen());
    }

    if (title == "Research Matches") {
      openScreen(context, const ResearchMatchesScreen());
    }

    if (title == "Research Messages") {
      openScreen(context, const ResearchMessagesScreen());
    }

    if (title == "Research Profile") {
      openScreen(context, const ResearchProfileScreen());
    }

    if (title == "Connections") {
      openScreen(context, const ConnectionsScreen());
    }

    if (title == "Research Feed") {
      openScreen(context, const ResearchFeedScreen());
    }

    if (title == "Find Researchers") {
      openScreen(context, const ResearcherScreen());
    }

    if (title == "AI Chat") {
      openScreen(context, const AIChatScreen());
    }

    if (title == "Upload Paper") {
      openScreen(context, const UploadPaperScreen());
    }

    if (title == "AI Summary") {
      openScreen(context, const SummaryScreen());
    }

    if (title == "Experiment Tracker") {
      openScreen(context, const ExperimentTrackerScreen());
    }

    if (title == "Research Notes") {
      openScreen(context, const ResearchNotesScreen());
    }

    if (title == "Project Docs") {
      openScreen(context, const ProjectDocsScreen());
    }
  }

  IconData featureIcon(String title) {
    if (title == "Notifications") return Icons.notifications_none;
    if (title == "Swipe Match") return Icons.swipe_outlined;
    if (title == "Research Matches") return Icons.favorite_border;
    if (title == "Research Messages") return Icons.forum_outlined;
    if (title == "Research Profile") return Icons.account_circle_outlined;
    if (title == "Connections") return Icons.handshake_outlined;
    if (title == "Research Feed") return Icons.dynamic_feed_outlined;
    if (title == "Find Researchers") return Icons.people_alt_outlined;
    if (title == "AI Chat") return Icons.chat_bubble_outline;
    if (title == "Upload Paper") return Icons.picture_as_pdf_outlined;
    if (title == "AI Summary") return Icons.auto_awesome;
    if (title == "Experiment Tracker") return Icons.science_outlined;
    if (title == "Research Notes") return Icons.note_alt_outlined;
    if (title == "Project Docs") return Icons.description_outlined;

    return Icons.apps;
  }

  Color featureColor(BuildContext context, String title) {
    if (title == "Notifications") return Colors.orangeAccent;
    if (title == "Swipe Match") return Colors.pinkAccent;
    if (title == "Research Matches") return Colors.pinkAccent;
    if (title == "Research Messages") return Colors.blueAccent;
    if (title == "Research Profile") return Colors.indigoAccent;
    if (title == "Connections") return Colors.lightGreenAccent;
    if (title == "Research Feed") return Colors.cyanAccent;
    if (title == "Find Researchers") {
      return Theme.of(context).colorScheme.secondary;
    }
    if (title == "AI Chat") return Colors.tealAccent;
    if (title == "Upload Paper") return Colors.redAccent;
    if (title == "Experiment Tracker") return Colors.greenAccent;
    if (title == "Research Notes") return Colors.purpleAccent;
    if (title == "Project Docs") return Colors.orangeAccent;

    return Theme.of(context).colorScheme.primary;
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
    final secondary = Theme.of(context).colorScheme.secondary;
    final unread = NotificationService.unreadCount();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primary.withOpacity(0.28),
            secondary.withOpacity(0.18),
            Theme.of(context).cardColor,
          ],
        ),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  "Welcome back 👋",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => openScreen(context, const NotificationsScreen()),
                child: Stack(
                  children: [
                    Container(
                      height: 46,
                      width: 46,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: const Icon(
                        Icons.notifications_none,
                        color: Colors.white,
                      ),
                    ),
                    if (unread > 0)
                      Positioned(
                        right: 5,
                        top: 5,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Colors.orangeAccent,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            unread.toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            AuthService.currentUser ?? "Researcher",
            style: TextStyle(
              color: primary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            "Build your academic identity, share research updates, find collaborators, summarize papers, and organize your research workflow.",
            style: TextStyle(color: Colors.white70, height: 1.55, fontSize: 15),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () =>
                      openScreen(context, const ResearchProfileScreen()),
                  icon: const Icon(Icons.account_circle_outlined),
                  label: const Text("My Profile"),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 50,
                width: 52,
                child: ElevatedButton(
                  onPressed: () =>
                      openScreen(context, const ResearchFeedScreen()),
                  child: const Icon(Icons.dynamic_feed_outlined),
                ),
              ),
            ],
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
            children: [
              Icon(icon, color: iconColor, size: 31),
              const SizedBox(height: 10),
              Text(
                count,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white60, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget quickAction({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Widget screen,
    required Color color,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => openScreen(context, screen),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            children: [
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
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

    if (NotificationService.notifications.isNotEmpty) {
      final latest = NotificationService.notifications.first;

      activities.add(
        recentActivityItem(
          context: context,
          icon: Icons.notifications_none,
          iconColor: Colors.orangeAccent,
          title: latest.title,
          subtitle: latest.body,
          screen: const NotificationsScreen(),
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
                  "No recent activity yet. Start by creating your research profile, posting an update, or generating a summary.",
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

  Widget featureCard(BuildContext context, Map<String, String> feature) {
    final title = feature["title"]!;
    final subtitle = feature["subtitle"]!;
    final color = featureColor(context, title);

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => openFeature(context, title),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(featureIcon(title), color: color, size: 28),
            ),
            const Spacer(),
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

  @override
  Widget build(BuildContext context) {
    final totalSummaries = SummaryService.savedSummaries.length;
    final favoriteSummaries = SummaryService.savedSummaries
        .where((summary) => summary.isFavorite)
        .length;
    final totalExperiments = ExperimentService.experiments.length;
    final totalNotes = NoteService.notes.length;
    final unreadNotifications = NotificationService.unreadCount();

    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Research Hub"),
        actions: [
          Stack(
            children: [
              IconButton(
                tooltip: "Notifications",
                onPressed: () =>
                    openScreen(context, const NotificationsScreen()),
                icon: const Icon(Icons.notifications_none),
              ),
              if (unreadNotifications > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.orangeAccent,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      unreadNotifications.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            tooltip: "Logout",
            onPressed: () => logout(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
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
              "Quick Actions",
              subtitle: "Jump directly into your academic social workflows.",
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                quickAction(
                  context: context,
                  icon: Icons.account_circle_outlined,
                  title: "Profile",
                  screen: const ResearchProfileScreen(),
                  color: Colors.indigoAccent,
                ),
                const SizedBox(width: 12),
                quickAction(
                  context: context,
                  icon: Icons.dynamic_feed_outlined,
                  title: "Feed",
                  screen: const ResearchFeedScreen(),
                  color: Colors.cyanAccent,
                ),
                const SizedBox(width: 12),
                quickAction(
                  context: context,
                  icon: Icons.notifications_none,
                  title: "Alerts",
                  screen: const NotificationsScreen(),
                  color: Colors.orangeAccent,
                ),
              ],
            ),

            const SizedBox(height: 28),

            sectionTitle("Recent Activity"),

            const SizedBox(height: 16),

            ...buildRecentActivities(context),

            const SizedBox(height: 28),

            sectionTitle(
              "Research Tools",
              subtitle:
                  "Everything you need to organize, socialize, and grow your research work.",
            ),

            const SizedBox(height: 16),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: features.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.03,
              ),
              itemBuilder: (context, index) {
                return featureCard(context, features[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}
