import '../models/chat_thread_model.dart';
import '../models/research_message_model.dart';

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
    return threads;
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
  }
}
