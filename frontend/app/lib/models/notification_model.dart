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

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "body": body,
      "type": type,
      "timeAgo": timeAgo,
      "targetId": targetId,
      "targetName": targetName,
      "payload": payload,
      "isRead": isRead,
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json["title"] ?? "",
      body: json["body"] ?? "",
      type: json["type"] ?? "",
      timeAgo: json["timeAgo"] ?? "Just now",
      targetId: json["targetId"],
      targetName: json["targetName"],
      payload: json["payload"] == null
          ? null
          : Map<String, dynamic>.from(json["payload"]),
      isRead: json["isRead"] ?? false,
    );
  }
}
