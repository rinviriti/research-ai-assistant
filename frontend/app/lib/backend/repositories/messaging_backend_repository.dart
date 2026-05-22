import '../../models/research_message_model.dart';
import '../../models/research_thread_model.dart';
import '../../services/research_messaging_service.dart';
import '../../services/session_service.dart';
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
    final threadId = ResearchMessagingService.threadId(researcherName);

    await MockDatabase.addDocument(
      collection: "chatThreads",
      data: {
        "threadId": threadId,
        "participantId": threadId,
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
    final threadId = ResearchMessagingService.threadId(researcherName);

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
        "threadId": threadId,
        "researcherName": researcherName,
        "university": university,
        "senderId": isMe
            ? SessionService.currentUser?.userId ?? "local_user"
            : threadId,
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
    return thread.toJson();
  }

  ResearchThreadModel threadFromPayload(Map<String, dynamic> data) {
    return ResearchThreadModel(
      threadId: data["threadId"] ?? "",
      participantId: data["participantId"] ?? "",
      researcherName: data["researcherName"] ?? "",
      university: data["university"] ?? "",
      lastMessage: data["lastMessage"] ?? "",
      updatedAt: TimeFormatterService.parse(data["updatedAt"]),
      unreadCount: data["unreadCount"] ?? 0,
    );
  }

  Map<String, dynamic> messageToPayload(ResearchMessageModel message) {
    return message.toJson();
  }

  ResearchMessageModel messageFromPayload(Map<String, dynamic> data) {
    return ResearchMessageModel(
      messageId: data["messageId"] ?? "",
      senderId: data["senderId"] ?? "",
      senderName: data["senderName"] ?? "",
      message: data["message"] ?? "",
      createdAt: TimeFormatterService.parse(data["createdAt"]),
      isMe: data["isMe"] ?? false,
    );
  }
}
