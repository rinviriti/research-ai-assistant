import 'package:flutter/material.dart';

import '../../../models/notification_model.dart';
import '../../../services/notification_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  IconData notificationIcon(String type) {
    if (type == "match") return Icons.favorite_outline;
    if (type == "message") return Icons.chat_bubble_outline;
    if (type == "connection") return Icons.person_add_alt_1;
    if (type == "comment") return Icons.comment_outlined;
    if (type == "post") return Icons.dynamic_feed_outlined;

    return Icons.notifications_none;
  }

  Color notificationColor(String type) {
    if (type == "match") return Colors.pinkAccent;
    if (type == "message") return Colors.blueAccent;
    if (type == "connection") return Colors.greenAccent;
    if (type == "comment") return Colors.orangeAccent;
    if (type == "post") return Colors.cyanAccent;

    return Theme.of(context).colorScheme.primary;
  }

  void markAllRead() {
    setState(() {
      NotificationService.markAllAsRead();
    });
  }

  void clearAll() {
    setState(() {
      NotificationService.clearAll();
    });
  }

  Widget notificationCard(NotificationModel notification) {
    final color = notificationColor(notification.type);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: notification.isRead ? Colors.white10 : color.withOpacity(0.45),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              notificationIcon(notification.type),
              color: color,
              size: 26,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (!notification.isRead)
                      Container(
                        height: 9,
                        width: 9,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 7),

                Text(
                  notification.body,
                  style: const TextStyle(color: Colors.white70, height: 1.45),
                ),

                const SizedBox(height: 10),

                Text(
                  notification.timeAgo,
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
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
            Icon(Icons.notifications_none, color: primary, size: 86),
            const SizedBox(height: 20),
            const Text(
              "No notifications yet",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "New matches, messages, comments, and connection requests will appear here.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget statsHeader() {
    final total = NotificationService.notifications.length;
    final unread = NotificationService.unreadCount();

    final primary = Theme.of(context).colorScheme.primary;

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
                  total.toString(),
                  style: TextStyle(
                    color: primary,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text("Total", style: TextStyle(color: Colors.white60)),
              ],
            ),
          ),
          Container(width: 1, height: 45, color: Colors.white12),
          Expanded(
            child: Column(
              children: [
                Text(
                  unread.toString(),
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
    final notifications = NotificationService.notifications;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Notifications"),
        actions: [
          IconButton(
            tooltip: "Mark all as read",
            onPressed: notifications.isEmpty ? null : markAllRead,
            icon: const Icon(Icons.done_all),
          ),
          IconButton(
            tooltip: "Clear all",
            onPressed: notifications.isEmpty ? null : clearAll,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: notifications.isEmpty
          ? emptyState()
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  "Activity Notifications",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Track research matches, messages, comments, and connection activity.",
                  style: TextStyle(color: Colors.white70, height: 1.5),
                ),

                const SizedBox(height: 24),

                statsHeader(),

                ...notifications.map(notificationCard),
              ],
            ),
    );
  }
}
