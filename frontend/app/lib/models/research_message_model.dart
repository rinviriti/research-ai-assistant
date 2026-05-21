import '../services/time_formatter_service.dart';

class ResearchMessageModel {
  final String messageId;
  final String senderName;
  final String message;
  final DateTime createdAt;
  final bool isMe;

  ResearchMessageModel({
    required this.messageId,
    required this.senderName,
    required this.message,
    required this.createdAt,
    required this.isMe,
  });

  String get timeAgo => TimeFormatterService.format(createdAt);

  Map<String, dynamic> toJson() {
    return {
      "messageId": messageId,
      "senderName": senderName,
      "message": message,
      "createdAt": createdAt.toIso8601String(),
      "isMe": isMe,
    };
  }

  factory ResearchMessageModel.fromJson(Map<String, dynamic> json) {
    return ResearchMessageModel(
      messageId: json["messageId"] ?? "",
      senderName: json["senderName"] ?? "",
      message: json["message"] ?? "",
      createdAt: TimeFormatterService.parse(json["createdAt"]),
      isMe: json["isMe"] ?? false,
    );
  }
}
