import 'package:flutter/material.dart';

import '../../../models/notification_model.dart';
import '../../../services/notification_service.dart';
import '../../feed/screens/post_detail_screen.dart';
import '../../messaging/screens/research_chat_detail_screen.dart';
import '../../researchers/screens/researcher_profile_preview_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  void openNotification(BuildContext context, NotificationModel notification) {
    NotificationService.markAsRead(notification);

    if (notification.type == "message") {
      final researcherName =
          notification.payload?["researcherName"] ??
          notification.targetName ??
          "Researcher";

      final university =
          notification.payload?["university"] ?? "Research Network";

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResearchChatDetailScreen(
            researcherName: researcherName,
            university: university,
          ),
        ),
      );

      return;
    }

    if (notification.type == "post" ||
        notification.type == "comment" ||
        notification.type == "saved") {
      if (notification.targetId == null) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PostDetailScreen(postId: notification.targetId!),
        ),
      );

      return;
    }

    if (notification.type == "connection" || notification.type == "match") {
      final researcherName =
          notification.payload?["researcherName"] ??
          notification.targetName ??
          "Researcher";

      final university =
          notification.payload?["university"] ?? "Research Network";

      final interests =
          (notification.payload?["interests"] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [];

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResearcherProfilePreviewScreen(
            name: researcherName,
            university: university,
            interests: interests,
          ),
        ),
      );

      return;
    }
  }

  Widget notificationIcon(BuildContext context, String type) {
    IconData icon = Icons.notifications_none;
    Color color = Theme.of(context).colorScheme.primary;

    if (type == "message") {
      icon = Icons.forum_outlined;
      color = Colors.lightBlueAccent;
    } else if (type == "post") {
      icon = Icons.dynamic_feed_outlined;
      color = Colors.greenAccent;
    } else if (type == "comment") {
      icon = Icons.comment_outlined;
      color = Colors.lightBlueAccent;
    } else if (type == "saved") {
      icon = Icons.bookmark_border;
      color = Colors.greenAccent;
    } else if (type == "connection") {
      icon = Icons.person_add_alt_1;
      color = Colors.orangeAccent;
    } else if (type == "match") {
      icon = Icons.favorite_border;
      color = Colors.pinkAccent;
    }

    return Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: color),
    );
  }

  Widget notificationCard(
    BuildContext context,
    NotificationModel notification,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => openNotification(context, notification),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: notification.isRead
                ? Colors.white10
                : Theme.of(context).colorScheme.primary.withOpacity(0.45),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            notificationIcon(context, notification.type),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: notification.isRead
                          ? FontWeight.w600
                          : FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    notification.body,
                    style: const TextStyle(
                      color: Colors.white70,
                      height: 1.4,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    notification.timeAgo,
                    style: const TextStyle(color: Colors.white38, fontSize: 11),
                  ),
                ],
              ),
            ),

            if (!notification.isRead)
              Container(
                height: 10,
                width: 10,
                margin: const EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
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
            Icon(Icons.notifications_none, color: primary, size: 86),

            const SizedBox(height: 20),

            const Text(
              "No notifications yet",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Messages, connection requests, post activity, and match updates will appear here.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget content(BuildContext context, List<NotificationModel> notifications) {
    if (notifications.isEmpty) {
      return emptyState(context);
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                "Notifications",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 31,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            TextButton(
              onPressed: NotificationService.markAllAsRead,
              child: const Text("Mark all read"),
            ),
          ],
        ),

        const SizedBox(height: 10),

        const Text(
          "Realtime updates from your RH+ research network.",
          style: TextStyle(color: Colors.white70, height: 1.5),
        ),

        const SizedBox(height: 24),

        ...notifications.map(
          (notification) => notificationCard(context, notification),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: StreamBuilder<List<NotificationModel>>(
        stream: NotificationService.stream,
        initialData: NotificationService.getNotifications(),
        builder: (context, snapshot) {
          final notifications = snapshot.data ?? [];

          return content(context, notifications);
        },
      ),
    );
  }
}
