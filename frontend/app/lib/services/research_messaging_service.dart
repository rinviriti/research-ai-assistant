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
          updatedAt: DateTime.now(),
          unreadCount: 0,
        ),
      );

      messages[id] = [];
    }
  }

  static List<ResearchThreadModel> getThreads() {
    threads.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    return threads;
  }

  static List<ResearchMessageModel> getMessages(String researcherName) {
    final id = threadId(researcherName);

    final threadMessages = messages[id] ?? [];

    threadMessages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    return threadMessages;
  }

  static void sendMessage({
    required String researcherName,
    required String university,
    required String message,
    bool isMe = true,
  }) {
    createThread(researcherName: researcherName, university: university);

    final id = threadId(researcherName);

    final now = DateTime.now();

    final newMessage = ResearchMessageModel(
      messageId: now.microsecondsSinceEpoch.toString(),
      senderName: isMe ? "You" : researcherName,
      message: message,
      createdAt: now,
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
        updatedAt: now,
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
      updatedAt: oldThread.updatedAt,
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
