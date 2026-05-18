import '../models/notification_model.dart';

class NotificationService {
  static final List<NotificationModel> notifications = [];

  static void addNotification({
    required String title,
    required String body,
    required String type,
  }) {
    notifications.insert(
      0,
      NotificationModel(
        title: title,
        body: body,
        type: type,
        timeAgo: "Just now",
      ),
    );
  }

  static int unreadCount() {
    return notifications.where((n) => !n.isRead).length;
  }

  static void markAllAsRead() {
    for (final notification in notifications) {
      notification.isRead = true;
    }
  }

  static void clearAll() {
    notifications.clear();
  }
}
