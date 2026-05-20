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
}
