import '../services/time_formatter_service.dart';

class ResearchThreadModel {
  final String threadId;
  final String researcherName;
  final String university;
  final String lastMessage;
  final DateTime updatedAt;
  final int unreadCount;

  ResearchThreadModel({
    required this.threadId,
    required this.researcherName,
    required this.university,
    required this.lastMessage,
    required this.updatedAt,
    required this.unreadCount,
  });

  String get timeAgo => TimeFormatterService.format(updatedAt);
}
