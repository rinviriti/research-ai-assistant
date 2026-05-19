import '../models/chat_thread_model.dart';
import '../models/research_message_model.dart';
import 'notification_service.dart';

class ResearchMessagingService {
  static final List<ResearchMessageModel> messages = [];
  static final List<ChatThreadModel> threads = [];

  static void createThread({
    required String researcherName,
    required String university,
  }) {
    final exists = threads.any(
      (thread) => thread.researcherName == researcherName,
    );

    if (exists) return;

    threads.add(
      ChatThreadModel(
        researcherName: researcherName,
        university: university,
        lastMessage: "Start a research conversation",
        timeAgo: "New",
      ),
    );
  }

  static List<ChatThreadModel> getThreads() {
    return threads.map((thread) {
      final threadMessages = getMessages(thread.researcherName);

      if (threadMessages.isEmpty) {
        return thread;
      }

      return ChatThreadModel(
        researcherName: thread.researcherName,
        university: thread.university,
        lastMessage: threadMessages.last.message,
        timeAgo: threadMessages.last.timeAgo,
      );
    }).toList();
  }

  static List<ResearchMessageModel> getMessages(String researcherName) {
    return messages
        .where((message) => message.researcherName == researcherName)
        .toList();
  }

  static void sendMessage({
    required String researcherName,
    required String message,
  }) {
    messages.add(
      ResearchMessageModel(
        researcherName: researcherName,
        message: message,
        isMe: true,
        timeAgo: "Now",
      ),
    );

    messages.add(
      ResearchMessageModel(
        researcherName: researcherName,
        message:
            "Thanks for your message. I would love to discuss this research topic further.",
        isMe: false,
        timeAgo: "Now",
      ),
    );

    NotificationService.addNotification(
      title: "New Research Message",
      body: "Conversation updated with $researcherName.",
      type: "message",
      targetName: researcherName,
    );
  }

  static void clearMessages() {
    messages.clear();
    threads.clear();
  }
}
