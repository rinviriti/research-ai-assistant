import '../models/research_message_model.dart';
import '../models/research_thread_model.dart';
import 'notification_service.dart';
import 'realtime_messaging_service.dart';

class ResearchMessagingService {
  static final List<ResearchThreadModel> threads = [];
  static final Map<String, List<ResearchMessageModel>> messages = {};

  static String threadId(String researcherName) {
    return researcherName.trim().toLowerCase().replaceAll(" ", "_");
  }

  static void createThread({
    required String researcherName,
    required String university,
  }) {
    final id = threadId(researcherName);

    final exists = threads.any((thread) => thread.threadId == id);

    if (!exists) {
      threads.insert(
        0,
        ResearchThreadModel(
          threadId: id,
          researcherName: researcherName,
          university: university,
          lastMessage: "Start a research conversation.",
          timeAgo: "Just now",
          unreadCount: 0,
        ),
      );

      messages[id] = [];
    }
  }

  static List<ResearchThreadModel> getThreads() {
    return threads;
  }

  static List<ResearchMessageModel> getMessages(String researcherName) {
    final id = threadId(researcherName);
    return messages[id] ?? [];
  }

  static void sendMessage({
    required String researcherName,
    required String university,
    required String message,
    bool isMe = true,
  }) {
    createThread(researcherName: researcherName, university: university);

    final id = threadId(researcherName);

    final newMessage = ResearchMessageModel(
      messageId: DateTime.now().microsecondsSinceEpoch.toString(),
      senderName: isMe ? "You" : researcherName,
      message: message,
      timeAgo: "Just now",
      isMe: isMe,
    );

    messages[id] ??= [];
    messages[id]!.add(newMessage);

    final threadIndex = threads.indexWhere((thread) => thread.threadId == id);

    if (threadIndex != -1) {
      final oldThread = threads[threadIndex];

      threads[threadIndex] = ResearchThreadModel(
        threadId: oldThread.threadId,
        researcherName: oldThread.researcherName,
        university: oldThread.university,
        lastMessage: message,
        timeAgo: "Just now",
        unreadCount: isMe ? oldThread.unreadCount : oldThread.unreadCount + 1,
      );

      final updatedThread = threads.removeAt(threadIndex);
      threads.insert(0, updatedThread);
    }

    if (!isMe) {
      NotificationService.addNotification(
        title: "New Research Message",
        body: "$researcherName sent you a message.",
        type: "message",
        targetId: id,
        targetName: researcherName,
      );
    }

    RealtimeMessagingService.notifyThread(researcherName);
  }

  static void receiveAutoReply({
    required String researcherName,
    required String university,
  }) {
    Future.delayed(const Duration(milliseconds: 650), () {
      sendMessage(
        researcherName: researcherName,
        university: university,
        message:
            "Thanks for reaching out. I would be happy to discuss possible research collaboration.",
        isMe: false,
      );
    });
  }

  static void markThreadAsRead(String researcherName) {
    final id = threadId(researcherName);

    final threadIndex = threads.indexWhere((thread) => thread.threadId == id);

    if (threadIndex == -1) return;

    final oldThread = threads[threadIndex];

    threads[threadIndex] = ResearchThreadModel(
      threadId: oldThread.threadId,
      researcherName: oldThread.researcherName,
      university: oldThread.university,
      lastMessage: oldThread.lastMessage,
      timeAgo: oldThread.timeAgo,
      unreadCount: 0,
    );
  }

  static int totalUnreadCount() {
    return threads.fold(0, (total, thread) => total + thread.unreadCount);
  }

  static void clearMessages() {
    threads.clear();
    messages.clear();
    RealtimeMessagingService.disposeAll();
  }
}
