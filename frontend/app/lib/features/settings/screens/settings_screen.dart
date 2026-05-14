import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkMode = true;
  bool notifications = true;

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
            "Account",

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
              children: const [
                ListTile(
                  leading: Icon(Icons.person, color: Colors.blueAccent),

                  title: Text("Profile", style: TextStyle(color: Colors.white)),
                ),

                Divider(color: Colors.white12),

                ListTile(
                  leading: Icon(Icons.lock, color: Colors.blueAccent),

                  title: Text(
                    "Privacy & Security",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
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
