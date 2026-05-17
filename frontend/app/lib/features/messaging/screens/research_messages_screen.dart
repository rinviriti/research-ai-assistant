import 'package:flutter/material.dart';

import '../../../models/chat_thread_model.dart';
import '../../../services/research_messaging_service.dart';
import 'research_chat_detail_screen.dart';

class ResearchMessagesScreen extends StatefulWidget {
  const ResearchMessagesScreen({super.key});

  @override
  State<ResearchMessagesScreen> createState() => _ResearchMessagesScreenState();
}

class _ResearchMessagesScreenState extends State<ResearchMessagesScreen> {
  Widget threadCard(ChatThreadModel thread) {
    final primary = Theme.of(context).colorScheme.primary;

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResearchChatDetailScreen(
              researcherName: thread.researcherName,
              university: thread.university,
            ),
          ),
        ).then((_) {
          setState(() {});
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: primary,
              child: Text(
                thread.researcherName.substring(0, 1),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    thread.researcherName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    thread.university,
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    thread.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: primary, size: 16),
          ],
        ),
      ),
    );
  }

  Widget emptyState() {
    return const Center(
      child: Text(
        "No research messages yet.\nUse Swipe Match first, then open chat from Research Matches.",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white70, height: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final threads = ResearchMessagingService.getThreads();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Research Messages")),
      body: threads.isEmpty
          ? emptyState()
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  "Research Conversations",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Message matched researchers and discuss collaboration opportunities.",
                  style: TextStyle(color: Colors.white70, height: 1.5),
                ),
                const SizedBox(height: 24),
                ...threads.map(threadCard),
              ],
            ),
    );
  }
}
