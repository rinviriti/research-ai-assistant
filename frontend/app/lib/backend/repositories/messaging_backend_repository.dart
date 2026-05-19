import '../../models/research_message_model.dart';
import '../../models/research_thread_model.dart';
import '../../services/research_messaging_service.dart';
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

    await MockDatabase.addDocument(
      collection: "chatThreads",
      data: {
        "threadId": ResearchMessagingService.threadId(researcherName),
        "researcherName": researcherName,
        "university": university,
        "lastMessage": "Start a research conversation.",
        "timeAgo": "Just now",
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
    ResearchMessagingService.sendMessage(
      researcherName: researcherName,
      university: university,
      message: message,
      isMe: isMe,
    );

    await MockDatabase.addDocument(
      collection: "messages",
      data: {
        "messageId": DateTime.now().microsecondsSinceEpoch.toString(),
        "threadId": ResearchMessagingService.threadId(researcherName),
        "researcherName": researcherName,
        "university": university,
        "senderName": isMe ? "You" : researcherName,
        "message": message,
        "timeAgo": "Just now",
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
      "timeAgo": thread.timeAgo,
      "unreadCount": thread.unreadCount,
    };
  }

  ResearchThreadModel threadFromPayload(Map<String, dynamic> data) {
    return ResearchThreadModel(
      threadId: data["threadId"] ?? "",
      researcherName: data["researcherName"] ?? "",
      university: data["university"] ?? "",
      lastMessage: data["lastMessage"] ?? "",
      timeAgo: data["timeAgo"] ?? "",
      unreadCount: data["unreadCount"] ?? 0,
    );
  }

  Map<String, dynamic> messageToPayload(ResearchMessageModel message) {
    return {
      "messageId": message.messageId,
      "senderName": message.senderName,
      "message": message.message,
      "timeAgo": message.timeAgo,
      "isMe": message.isMe,
    };
  }

  ResearchMessageModel messageFromPayload(Map<String, dynamic> data) {
    return ResearchMessageModel(
      messageId: data["messageId"] ?? "",
      senderName: data["senderName"] ?? "",
      message: data["message"] ?? "",
      timeAgo: data["timeAgo"] ?? "",
      isMe: data["isMe"] ?? false,
    );
  }
}
