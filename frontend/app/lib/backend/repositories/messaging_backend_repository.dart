import '../../models/chat_thread_model.dart';
import '../../models/research_message_model.dart';
import '../../services/research_messaging_service.dart';
import '../mock_backend/mock_database.dart';

class MessagingBackendRepository {
  Future<List<ChatThreadModel>> getThreads() async {
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
      data: {"researcherName": researcherName, "university": university},
    );
  }

  Future<void> sendMessage({
    required String researcherName,
    required String message,
  }) async {
    ResearchMessagingService.sendMessage(
      researcherName: researcherName,
      message: message,
    );

    await MockDatabase.addDocument(
      collection: "messages",
      data: {
        "researcherName": researcherName,
        "message": message,
        "timeAgo": "Now",
      },
    );
  }

  Map<String, dynamic> messageToPayload(ResearchMessageModel message) {
    return {
      "researcherName": message.researcherName,
      "message": message.message,
      "isMe": message.isMe,
      "timeAgo": message.timeAgo,
    };
  }

  ResearchMessageModel messageFromPayload(Map<String, dynamic> data) {
    return ResearchMessageModel(
      researcherName: data["researcherName"] ?? "",
      message: data["message"] ?? "",
      isMe: data["isMe"] ?? false,
      timeAgo: data["timeAgo"] ?? "",
    );
  }
}
