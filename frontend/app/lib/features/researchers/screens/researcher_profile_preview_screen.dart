import 'package:flutter/material.dart';

import '../../../services/research_messaging_service.dart';
import '../../messaging/screens/research_chat_detail_screen.dart';

class ResearcherProfilePreviewScreen extends StatelessWidget {
  final String name;
  final String university;
  final List<String> interests;

  const ResearcherProfilePreviewScreen({
    super.key,
    required this.name,
    required this.university,
    this.interests = const [],
  });

  void openMessage(BuildContext context) {
    ResearchMessagingService.createThread(
      researcherName: name,
      university: university,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResearchChatDetailScreen(
          researcherName: name,
          university: university,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final profileInterests = interests.isEmpty
        ? ["Research", "Collaboration"]
        : interests;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Researcher Profile")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 58,
                  backgroundColor: primary,
                  child: Text(
                    name.substring(0, 1),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  university,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, height: 1.4),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: () => openMessage(context),
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: const Text("Message Researcher"),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 26),

          const Text(
            "Research Interests",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          Wrap(
            children: profileInterests.map((interest) {
              return Container(
                margin: const EdgeInsets.only(right: 8, bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: primary.withOpacity(0.30)),
                ),
                child: Text(
                  interest,
                  style: TextStyle(color: primary, fontWeight: FontWeight.w600),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 26),

          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.white10),
            ),
            child: const Text(
              "This profile preview helps you quickly inspect a researcher and start a conversation from feed posts, search results, matches, and saved posts.",
              style: TextStyle(color: Colors.white70, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
