import 'package:flutter/material.dart';

import '../../../models/research_thread_model.dart';
import '../../../services/research_messaging_service.dart';
import 'research_chat_detail_screen.dart';

class ResearchMessagesScreen extends StatefulWidget {
  const ResearchMessagesScreen({super.key});

  @override
  State<ResearchMessagesScreen> createState() => _ResearchMessagesScreenState();
}

class _ResearchMessagesScreenState extends State<ResearchMessagesScreen> {
  List<ResearchThreadModel> threads = [];

  @override
  void initState() {
    super.initState();
    loadThreads();
  }

  void loadThreads() {
    setState(() {
      threads = ResearchMessagingService.getThreads();
    });
  }

  void openChat(ResearchThreadModel thread) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResearchChatDetailScreen(
          researcherName: thread.researcherName,
          university: thread.university,
        ),
      ),
    ).then((_) {
      ResearchMessagingService.markThreadAsRead(thread.researcherName);
      loadThreads();
    });
  }

  Widget threadCard(ResearchThreadModel thread) {
    final primary = Theme.of(context).colorScheme.primary;

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => openChat(thread),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
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
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    thread.university,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white60, fontSize: 12),
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

            const SizedBox(width: 10),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  thread.timeAgo,
                  style: const TextStyle(color: Colors.white38, fontSize: 11),
                ),

                const SizedBox(height: 10),

                if (thread.unreadCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      thread.unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white30,
                    size: 15,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget emptyState() {
    final primary = Theme.of(context).colorScheme.primary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.forum_outlined, color: primary, size: 84),

            const SizedBox(height: 20),

            const Text(
              "No research messages yet",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Start a conversation from researcher profiles, search results, or research matches.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget headerCard() {
    final primary = Theme.of(context).colorScheme.primary;
    final unreadCount = ResearchMessagingService.totalUnreadCount();

    return Container(
      margin: const EdgeInsets.only(bottom: 22),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
        gradient: LinearGradient(
          colors: [primary.withOpacity(0.18), Theme.of(context).cardColor],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  threads.length.toString(),
                  style: TextStyle(
                    color: primary,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text("Threads", style: TextStyle(color: Colors.white60)),
              ],
            ),
          ),

          Container(width: 1, height: 45, color: Colors.white12),

          Expanded(
            child: Column(
              children: [
                Text(
                  unreadCount.toString(),
                  style: const TextStyle(
                    color: Colors.orangeAccent,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text("Unread", style: TextStyle(color: Colors.white60)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    threads = ResearchMessagingService.getThreads();

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
                  "Chat with researchers, collaborators, supervisors, and academic matches.",
                  style: TextStyle(color: Colors.white70, height: 1.5),
                ),

                const SizedBox(height: 24),

                headerCard(),

                ...threads.map(threadCard),
              ],
            ),
    );
  }
}
