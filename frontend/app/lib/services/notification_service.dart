import '../models/notification_model.dart';

class NotificationService {
  static final List<NotificationModel> notifications = [];

  static void addNotification({
    required String title,
    required String body,
    required String type,
    String? targetId,
    String? targetName,
  }) {
    notifications.insert(
      0,
      NotificationModel(
        title: title,
        body: body,
        type: type,
        timeAgo: "Just now",
        targetId: targetId,
        targetName: targetName,
      ),
    );
  }

  static int unreadCount() {
    return notifications.where((notification) => !notification.isRead).length;
  }

  static void markAsRead(NotificationModel notification) {
    notification.isRead = true;
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
