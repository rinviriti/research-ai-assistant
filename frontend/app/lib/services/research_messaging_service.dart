import '../models/chat_thread_model.dart';
import '../models/research_message_model.dart';
import 'swipe_match_service.dart';

class ResearchMessagingService {
  static final List<ResearchMessageModel> messages = [];

  static final List<ChatThreadModel> manualThreads = [];

  static void createThread({
    required String researcherName,
    required String university,
  }) {
    final exists = manualThreads.any(
      (thread) => thread.researcherName == researcherName,
    );

    if (exists) return;

    manualThreads.add(
      ChatThreadModel(
        researcherName: researcherName,
        university: university,
        lastMessage: "Start a research conversation",
        timeAgo: "New chat",
      ),
    );
  }

  static List<ChatThreadModel> getThreads() {
    final matchThreads = SwipeMatchService.matches.map((match) {
      final threadMessages = getMessages(match.researcherName);

      return ChatThreadModel(
        researcherName: match.researcherName,
        university: match.university,
        lastMessage: threadMessages.isEmpty
            ? "Start a research conversation"
            : threadMessages.last.message,
        timeAgo: threadMessages.isEmpty
            ? "New match"
            : threadMessages.last.timeAgo,
      );
    }).toList();

    final allThreads = [...manualThreads, ...matchThreads];

    final uniqueThreads = <String, ChatThreadModel>{};

    for (final thread in allThreads) {
      uniqueThreads[thread.researcherName] = ChatThreadModel(
        researcherName: thread.researcherName,
        university: thread.university,
        lastMessage: getMessages(thread.researcherName).isEmpty
            ? thread.lastMessage
            : getMessages(thread.researcherName).last.message,
        timeAgo: getMessages(thread.researcherName).isEmpty
            ? thread.timeAgo
            : getMessages(thread.researcherName).last.timeAgo,
      );
    }

    return uniqueThreads.values.toList();
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
        timeAgo: "Just now",
      ),
    );

    messages.add(
      ResearchMessageModel(
        researcherName: researcherName,
        message:
            "Thanks for reaching out. I would be interested to discuss possible research collaboration.",
        isMe: false,
        timeAgo: "Just now",
      ),
    );
  }
}
