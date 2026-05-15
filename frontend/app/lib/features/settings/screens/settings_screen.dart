import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/screens/login_screen.dart';
import '../../../services/auth_service.dart';
import '../../../services/summary_service.dart';
import '../../../services/experiment_service.dart';
import '../../../services/note_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkMode = true;
  bool notifications = true;

  Future<void> resetAppData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();

    SummaryService.savedSummaries.clear();
    ExperimentService.experiments.clear();
    NoteService.notes.clear();
    AuthService.currentUser = null;

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("All app data reset successfully.")),
    );

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
          backgroundColor: const Color(0xFF1E293B),
          title: const Text(
            "Reset App Data?",
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            "This will delete your saved account, summaries, notes, experiments, and profile data.",
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Preferences",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  value: darkMode,
                  onChanged: (value) {
                    setState(() {
                      darkMode = value;
                    });
                  },
                  title: const Text(
                    "Dark Mode",
                    style: TextStyle(color: Colors.white),
                  ),
                  secondary: const Icon(
                    Icons.dark_mode,
                    color: Colors.blueAccent,
                  ),
                ),
                const Divider(color: Colors.white12),
                SwitchListTile(
                  value: notifications,
                  onChanged: (value) {
                    setState(() {
                      notifications = value;
                    });
                  },
                  title: const Text(
                    "Notifications",
                    style: TextStyle(color: Colors.white),
                  ),
                  secondary: const Icon(
                    Icons.notifications,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            "Developer Tools",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(18),
            ),
            child: ListTile(
              onTap: confirmReset,
              leading: const Icon(
                Icons.delete_forever,
                color: Colors.redAccent,
              ),
              title: const Text(
                "Reset App Data",
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                "Clear account, summaries, experiments, notes, and profile data",
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            "About",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Research AI Assistant",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text("Version 1.0.0", style: TextStyle(color: Colors.white70)),
                SizedBox(height: 10),
                Text(
                  "An AI-powered research productivity app built with Flutter.",
                  style: TextStyle(color: Colors.white70, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
