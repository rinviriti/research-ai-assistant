class NotificationModel {
  final String title;
  final String body;
  final String type;
  final String timeAgo;
  bool isRead;

  NotificationModel({
    required this.title,
    required this.body,
    required this.type,
    required this.timeAgo,
    this.isRead = false,
  });
}
