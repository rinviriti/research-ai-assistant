import '../../models/research_message_model.dart';
import '../../models/research_thread_model.dart';
import '../../services/research_messaging_service.dart';
import '../../services/time_formatter_service.dart';
import '../mock_backend/mock_database.dart';

class MessagingBackendRepository {
  Future<List<ResearchThreadModel>> getThreads() async {
    return ResearchMessagingService.getThreads();
  }

  Future<List<ResearchMessageModel>> getMessages(String researcherName) async {
    return ResearchMessagingService.getMessages(researcherName);
  }

  Future<void> createThread({
    required String researcherName,
    required String university,
  }) async {
    ResearchMessagingService.createThread(
      researcherName: researcherName,
      university: university,
    );

    final now = DateTime.now();

    await MockDatabase.addDocument(
      collection: "chatThreads",
      data: {
        "threadId": ResearchMessagingService.threadId(researcherName),
        "researcherName": researcherName,
        "university": university,
        "lastMessage": "Start a research conversation.",
        "updatedAt": now.toIso8601String(),
        "unreadCount": 0,
      },
    );
  }

  Future<void> sendMessage({
    required String researcherName,
    required String university,
    required String message,
    bool isMe = true,
  }) async {
    final now = DateTime.now();

    ResearchMessagingService.sendMessage(
      researcherName: researcherName,
      university: university,
      message: message,
      isMe: isMe,
    );

    await MockDatabase.addDocument(
      collection: "messages",
      data: {
        "messageId": now.microsecondsSinceEpoch.toString(),
        "threadId": ResearchMessagingService.threadId(researcherName),
        "researcherName": researcherName,
        "university": university,
        "senderName": isMe ? "You" : researcherName,
        "message": message,
        "createdAt": now.toIso8601String(),
        "isMe": isMe,
      },
    );
  }

  Future<void> markThreadAsRead(String researcherName) async {
    ResearchMessagingService.markThreadAsRead(researcherName);
  }

  Future<int> totalUnreadCount() async {
    return ResearchMessagingService.totalUnreadCount();
  }

  Map<String, dynamic> threadToPayload(ResearchThreadModel thread) {
    return {
      "threadId": thread.threadId,
      "researcherName": thread.researcherName,
      "university": thread.university,
      "lastMessage": thread.lastMessage,
      "updatedAt": thread.updatedAt.toIso8601String(),
      "unreadCount": thread.unreadCount,
    };
  }

  ResearchThreadModel threadFromPayload(Map<String, dynamic> data) {
    return ResearchThreadModel(
      threadId: data["threadId"] ?? "",
      researcherName: data["researcherName"] ?? "",
      university: data["university"] ?? "",
      lastMessage: data["lastMessage"] ?? "",
      updatedAt: TimeFormatterService.parse(data["updatedAt"]),
      unreadCount: data["unreadCount"] ?? 0,
    );
  }

  Map<String, dynamic> messageToPayload(ResearchMessageModel message) {
    return {
      "messageId": message.messageId,
      "senderName": message.senderName,
      "message": message.message,
      "createdAt": message.createdAt.toIso8601String(),
      "isMe": message.isMe,
    };
  }

  ResearchMessageModel messageFromPayload(Map<String, dynamic> data) {
    return ResearchMessageModel(
      messageId: data["messageId"] ?? "",
      senderName: data["senderName"] ?? "",
      message: data["message"] ?? "",
      createdAt: TimeFormatterService.parse(data["createdAt"]),
      isMe: data["isMe"] ?? false,
    );
  }
}
