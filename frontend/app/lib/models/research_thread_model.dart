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

  Map<String, dynamic> toJson() {
    return {
      "threadId": threadId,
      "researcherName": researcherName,
      "university": university,
      "lastMessage": lastMessage,
      "updatedAt": updatedAt.toIso8601String(),
      "unreadCount": unreadCount,
    };
  }

  factory ResearchThreadModel.fromJson(Map<String, dynamic> json) {
    return ResearchThreadModel(
      threadId: json["threadId"] ?? "",
      researcherName: json["researcherName"] ?? "",
      university: json["university"] ?? "",
      lastMessage: json["lastMessage"] ?? "",
      updatedAt: TimeFormatterService.parse(json["updatedAt"]),
      unreadCount: json["unreadCount"] ?? 0,
    );
  }
}
