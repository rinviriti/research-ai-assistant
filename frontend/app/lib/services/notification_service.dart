import 'dart:async';

import '../models/notification_model.dart';
import 'local_storage_service.dart';

class NotificationService {
  static final List<NotificationModel> notifications = [];

  static final StreamController<List<NotificationModel>> _controller =
      StreamController<List<NotificationModel>>.broadcast();

  static const String storageKey = "rh_notifications";

  static Stream<List<NotificationModel>> get stream {
    Future.microtask(sync);
    return _controller.stream;
  }

  static void sync() {
    if (!_controller.isClosed) {
      _controller.add(List<NotificationModel>.from(notifications));
    }

    saveNotifications();
  }

  static List<NotificationModel> getNotifications() {
    return List<NotificationModel>.from(notifications);
  }

  static Future<void> loadNotifications() async {
    final data = await LocalStorageService.getJson(storageKey);

    if (data == null) return;

    notifications.clear();

    notifications.addAll(
      (data as List)
          .map(
            (item) =>
                NotificationModel.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList(),
    );

    sync();
  }

  static Future<void> saveNotifications() async {
    await LocalStorageService.saveJson(
      key: storageKey,
      data: notifications.map((e) => e.toJson()).toList(),
    );
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

  static int unreadCount() {
    return notifications.where((notification) => !notification.isRead).length;
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
