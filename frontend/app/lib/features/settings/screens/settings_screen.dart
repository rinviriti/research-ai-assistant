import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/screens/login_screen.dart';
import '../../about/screens/about_project_screen.dart';
import '../../help/screens/help_screen.dart';
import '../../feed/screens/saved_posts_screen.dart';
import '../../research_profile/screens/research_profile_screen.dart';
import '../../messaging/screens/research_messages_screen.dart';
import '../../notifications/screens/notifications_screen.dart';

import '../../../services/auth_service.dart';
import '../../../services/summary_service.dart';
import '../../../services/experiment_service.dart';
import '../../../services/note_service.dart';
import '../../../services/notification_service.dart';
import '../../../services/saved_post_service.dart';
import '../../../services/share_service.dart';
import '../../../services/comment_service.dart';
import '../../../services/post_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkMode = true;
  bool notifications = true;
  bool researchUpdates = true;
  bool messageAlerts = true;

  Future<void> resetAppData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    SummaryService.savedSummaries.clear();
    ExperimentService.experiments.clear();
    NoteService.notes.clear();
    NotificationService.clearAll();
    SavedPostService.clearSavedPosts();
    ShareService.clearShares();
    CommentService.clearComments();
    PostService.clearPosts();
    AuthService.currentUser = null;

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  void confirmReset() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: const Text(
            "Reset App Data?",
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            "This will delete local account data, summaries, notes, experiments, saved posts, comments, shares, and notifications.",
            style: TextStyle(color: Colors.white70, height: 1.45),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                resetAppData();
              },
              child: const Text(
                "Reset",
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  void logout() async {
    await AuthService.logout();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  void openScreen(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  Widget headerCard() {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primary.withOpacity(0.25), Theme.of(context).cardColor],
        ),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: primary,
            child: const Icon(Icons.person, color: Colors.black, size: 38),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AuthService.currentUser ?? "Researcher",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Manage your account, research tools, preferences, and local app data.",
                  style: TextStyle(color: Colors.white70, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionTitle(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(top: 28, bottom: 14),
      child: Column(
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
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white60, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget sectionContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white10),
      ),
      child: child,
    );
  }

  Widget settingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    final color = iconColor ?? Theme.of(context).colorScheme.primary;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
      onTap: onTap,
      leading: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          color: color.withOpacity(0.14),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.white60, height: 1.35),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.white38,
        size: 16,
      ),
    );
  }

  Widget switchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required void Function(bool value) onChanged,
  }) {
    final primary = Theme.of(context).colorScheme.primary;

    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
      value: value,
      onChanged: onChanged,
      activeThumbColor: primary,
      secondary: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          color: primary.withOpacity(0.14),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(icon, color: primary),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.white60, height: 1.35),
      ),
    );
  }

  Widget divider() {
    return const Divider(
      color: Colors.white10,
      height: 1,
      indent: 18,
      endIndent: 18,
    );
  }

  Widget appInfoCard() {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Icon(Icons.auto_awesome, color: primary, size: 44),
          const SizedBox(height: 12),
          Text(
            "Research AI Assistant",
            style: TextStyle(
              color: primary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text("Version 1.0.0", style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 6),
          const Text(
            "Academic networking, research productivity, and AI-assisted workflow platform.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget dangerButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton.icon(
        onPressed: confirmReset,
        icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
        label: const Text(
          "Reset All Local App Data",
          style: TextStyle(color: Colors.redAccent),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.redAccent),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }

  Widget logoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: logout,
        icon: const Icon(Icons.logout),
        label: const Text("Logout"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          headerCard(),

          sectionTitle(
            "Account",
            "Manage your academic identity and personal research workspace.",
          ),

          sectionContainer(
            child: Column(
              children: [
                settingsTile(
                  icon: Icons.account_circle_outlined,
                  title: "Research Profile",
                  subtitle: "Edit your academic profile and research identity",
                  onTap: () => openScreen(const ResearchProfileScreen()),
                  iconColor: primary,
                ),
                divider(),
                settingsTile(
                  icon: Icons.bookmark_border,
                  title: "Saved Posts",
                  subtitle: "Open your saved research reading library",
                  onTap: () => openScreen(const SavedPostsScreen()),
                  iconColor: Colors.amber,
                ),
                divider(),
                settingsTile(
                  icon: Icons.forum_outlined,
                  title: "Messages",
                  subtitle: "View your research conversations",
                  onTap: () => openScreen(const ResearchMessagesScreen()),
                  iconColor: Colors.blueAccent,
                ),
              ],
            ),
          ),

          sectionTitle(
            "Preferences",
            "Control app appearance and notification behavior.",
          ),

          sectionContainer(
            child: Column(
              children: [
                switchTile(
                  icon: Icons.dark_mode_outlined,
                  title: "Dark Mode",
                  subtitle: "Keep the professional dark research workspace",
                  value: darkMode,
                  onChanged: (value) {
                    setState(() {
                      darkMode = value;
                    });
                  },
                ),
                divider(),
                switchTile(
                  icon: Icons.notifications_none,
                  title: "Notifications",
                  subtitle:
                      "Receive alerts for comments, replies, messages, and matches",
                  value: notifications,
                  onChanged: (value) {
                    setState(() {
                      notifications = value;
                    });
                  },
                ),
                divider(),
                switchTile(
                  icon: Icons.dynamic_feed_outlined,
                  title: "Research Updates",
                  subtitle: "Show activity alerts from feed interactions",
                  value: researchUpdates,
                  onChanged: (value) {
                    setState(() {
                      researchUpdates = value;
                    });
                  },
                ),
                divider(),
                switchTile(
                  icon: Icons.chat_bubble_outline,
                  title: "Message Alerts",
                  subtitle: "Notify when matched researchers message you",
                  value: messageAlerts,
                  onChanged: (value) {
                    setState(() {
                      messageAlerts = value;
                    });
                  },
                ),
              ],
            ),
          ),

          sectionTitle(
            "Activity",
            "Review recent alerts and research engagement.",
          ),

          sectionContainer(
            child: Column(
              children: [
                settingsTile(
                  icon: Icons.notifications_active_outlined,
                  title: "Notifications Center",
                  subtitle:
                      "${NotificationService.unreadCount()} unread notifications",
                  onTap: () => openScreen(const NotificationsScreen()),
                  iconColor: Colors.orangeAccent,
                ),
              ],
            ),
          ),

          sectionTitle(
            "Support",
            "Learn about the project and get help using the app.",
          ),

          sectionContainer(
            child: Column(
              children: [
                settingsTile(
                  icon: Icons.help_outline,
                  title: "Help & Guide",
                  subtitle:
                      "Learn how to use research tools and social features",
                  onTap: () => openScreen(const HelpScreen()),
                  iconColor: primary,
                ),
                divider(),
                settingsTile(
                  icon: Icons.info_outline,
                  title: "About Project",
                  subtitle: "View app information, purpose, and tech stack",
                  onTap: () => openScreen(const AboutProjectScreen()),
                  iconColor: primary,
                ),
              ],
            ),
          ),

          sectionTitle(
            "Session",
            "Manage login state and local development data.",
          ),

          logoutButton(),

          const SizedBox(height: 14),

          dangerButton(),

          const SizedBox(height: 28),

          appInfoCard(),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
