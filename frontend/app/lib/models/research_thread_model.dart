import '../services/time_formatter_service.dart';

class ResearchThreadModel {
  final String threadId;

  final String participantId;
  final String researcherName;
  final String university;

  final String lastMessage;

  final DateTime updatedAt;

  final int unreadCount;

  ResearchThreadModel({
    required this.threadId,
    required this.participantId,
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
      "participantId": participantId,
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
      participantId: json["participantId"] ?? "",
      researcherName: json["researcherName"] ?? "",
      university: json["university"] ?? "",
      lastMessage: json["lastMessage"] ?? "",
      updatedAt: TimeFormatterService.parse(json["updatedAt"]),
      unreadCount: json["unreadCount"] ?? 0,
    );
  }
}
