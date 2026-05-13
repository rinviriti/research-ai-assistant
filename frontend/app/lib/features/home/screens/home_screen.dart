import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';
import '../../auth/screens/login_screen.dart';
import '../../paper/screens/upload_paper_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Map<String, String>> features = const [
    {
      "title": "Upload Paper",
      "subtitle": "Add research papers for AI analysis",
    },
    {"title": "AI Summary", "subtitle": "Generate structured summaries"},
    {"title": "Experiment Tracker", "subtitle": "Track datasets and models"},
    {
      "title": "Project Docs",
      "subtitle": "Generate GitHub-ready documentation",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text("Dashboard"),

        actions: [
          IconButton(
            onPressed: () {
              AuthService.logout();

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
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

                    onTap: () {
                      if (feature["title"] == "Upload Paper") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UploadPaperScreen(),
                          ),
                        );
                      }
                    },

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
