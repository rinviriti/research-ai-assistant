class NotificationModel {
  final String title;
  final String body;
  final String type;
  final String timeAgo;

  final String? targetId;
  final String? targetName;

  final Map<String, dynamic>? payload;

  bool isRead;

  NotificationModel({
    required this.title,
    required this.body,
    required this.type,
    required this.timeAgo,
    this.targetId,
    this.targetName,
    this.payload,
    this.isRead = false,
  });
}
