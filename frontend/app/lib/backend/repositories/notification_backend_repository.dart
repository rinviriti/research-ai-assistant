import '../../models/notification_model.dart';
import '../../services/notification_service.dart';
import '../mock_backend/mock_database.dart';

class NotificationBackendRepository {
  Future<List<NotificationModel>> getNotifications() async {
    return NotificationService.notifications;
  }

  Future<void> addNotification({
    required String title,
    required String body,
    required String type,
  }) async {
    NotificationService.addNotification(title: title, body: body, type: type);

    await MockDatabase.addDocument(
      collection: "notifications",
      data: {
        "title": title,
        "body": body,
        "type": type,
        "timeAgo": "Just now",
        "isRead": false,
      },
    );
  }

  Future<int> unreadCount() async {
    return NotificationService.unreadCount();
  }

  Future<void> markAllAsRead() async {
    NotificationService.markAllAsRead();
  }

  Future<void> clearAll() async {
    NotificationService.clearAll();
    await MockDatabase.clearCollection("notifications");
  }

  Map<String, dynamic> toBackendPayload(NotificationModel notification) {
    return {
      "title": notification.title,
      "body": notification.body,
      "type": notification.type,
      "timeAgo": notification.timeAgo,
      "isRead": notification.isRead,
    };
  }

  NotificationModel fromBackendPayload(Map<String, dynamic> data) {
    return NotificationModel(
      title: data["title"] ?? "",
      body: data["body"] ?? "",
      type: data["type"] ?? "",
      timeAgo: data["timeAgo"] ?? "",
      isRead: data["isRead"] ?? false,
    );
  }
}
