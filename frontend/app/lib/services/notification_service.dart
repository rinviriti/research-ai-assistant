import 'dart:async';

import '../models/notification_model.dart';

class NotificationService {
  static final List<NotificationModel> notifications = [];

  static final StreamController<List<NotificationModel>> _controller =
      StreamController<List<NotificationModel>>.broadcast();

  static Stream<List<NotificationModel>> get stream {
    Future.microtask(sync);
    return _controller.stream;
  }

  static void sync() {
    if (!_controller.isClosed) {
      _controller.add(List<NotificationModel>.from(notifications));
    }
  }

  static void addNotification({
    required String title,
    required String body,
    required String type,
    String? targetId,
    String? targetName,
    Map<String, dynamic>? payload,
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
        payload: payload,
      ),
    );

    sync();
  }

  static List<NotificationModel> getNotifications() {
    return List<NotificationModel>.from(notifications);
  }

  static int unreadCount() {
    return notifications.where((n) => !n.isRead).length;
  }

  static void markAsRead(NotificationModel notification) {
    notification.isRead = true;
    sync();
  }

  static void markAllAsRead() {
    for (final notification in notifications) {
      notification.isRead = true;
    }

    sync();
  }

  static void clearAll() {
    notifications.clear();
    sync();
  }
}
