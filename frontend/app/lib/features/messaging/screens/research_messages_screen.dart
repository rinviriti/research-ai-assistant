import 'package:flutter/material.dart';

import '../../../models/research_thread_model.dart';
import '../../../services/research_messaging_service.dart';
import 'research_chat_detail_screen.dart';

class ResearchMessagesScreen extends StatelessWidget {
  const ResearchMessagesScreen({super.key});

  void openChat(BuildContext context, ResearchThreadModel thread) {
    ResearchMessagingService.markThreadAsRead(thread.researcherName);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResearchChatDetailScreen(
          researcherName: thread.researcherName,
          university: thread.university,
        ),
      ),
    );
  }

  Widget emptyState(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.forum_outlined, size: 90, color: primary),
            const SizedBox(height: 22),
            const Text(
              "No research messages yet",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Start a conversation from researcher profiles, search results, or research matches.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                height: 1.5,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget threadCard(BuildContext context, ResearchThreadModel thread) {
    final primary = Theme.of(context).colorScheme.primary;

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => openChat(context, thread),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: thread.unreadCount > 0
                ? primary.withOpacity(0.35)
                : Colors.white10,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 29,
              backgroundColor: primary,
              child: Text(
                thread.researcherName.substring(0, 1),
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    thread.researcherName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: thread.unreadCount > 0
                          ? FontWeight.bold
                          : FontWeight.w600,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    thread.university,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    thread.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: thread.unreadCount > 0
                          ? Colors.white
                          : Colors.white60,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
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
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      thread.unreadCount > 9
                          ? "9+"
                          : thread.unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget content(BuildContext context, List<ResearchThreadModel> threads) {
    if (threads.isEmpty) {
      return emptyState(context);
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          "Research Messages",
          style: TextStyle(
            color: Colors.white,
            fontSize: 31,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "Your realtime academic conversations and collaboration discussions.",
          style: TextStyle(color: Colors.white70, height: 1.5),
        ),
        const SizedBox(height: 24),
        ...threads.map((thread) => threadCard(context, thread)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: StreamBuilder<List<ResearchThreadModel>>(
        stream: ResearchMessagingService.watchThreads(),
        initialData: ResearchMessagingService.getThreads(),
        builder: (context, snapshot) {
          final threads = snapshot.data ?? [];
          return content(context, threads);
        },
      ),
    );
  }
}
