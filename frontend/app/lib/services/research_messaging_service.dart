import '../models/research_message_model.dart';
import '../models/research_thread_model.dart';
import 'local_storage_service.dart';
import 'notification_service.dart';
import 'realtime_messaging_service.dart';

class ResearchMessagingService {
  static final List<ResearchThreadModel> threads = [];
  static final Map<String, List<ResearchMessageModel>> messages = {};

  static const String threadStorageKey = "rh_threads";
  static const String messageStorageKey = "rh_messages";

  static String threadId(String researcherName) {
    return researcherName.trim().toLowerCase().replaceAll(" ", "_");
  }

  static Future<void> loadMessages() async {
    final threadData = await LocalStorageService.getJson(threadStorageKey);
    final messageData = await LocalStorageService.getJson(messageStorageKey);

    threads.clear();
    messages.clear();

    if (threadData != null) {
      threads.addAll(
        (threadData as List)
            .map(
              (item) =>
                  ResearchThreadModel.fromJson(Map<String, dynamic>.from(item)),
            )
            .toList(),
      );
    }

    if (messageData != null) {
      final mapped = Map<String, dynamic>.from(messageData);

      mapped.forEach((key, value) {
        messages[key] = (value as List)
            .map(
              (item) => ResearchMessageModel.fromJson(
                Map<String, dynamic>.from(item),
              ),
            )
            .toList();
      });
    }

    syncThreads();

    for (final thread in threads) {
      syncMessages(thread.researcherName);
    }
  }

  static Future<void> saveMessages() async {
    await LocalStorageService.saveJson(
      key: threadStorageKey,
      data: threads.map((thread) => thread.toJson()).toList(),
    );

    final encodedMessages = <String, dynamic>{};

    messages.forEach((key, value) {
      encodedMessages[key] = value.map((message) => message.toJson()).toList();
    });

    await LocalStorageService.saveJson(
      key: messageStorageKey,
      data: encodedMessages,
    );
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

    syncThreads();
    syncMessages(researcherName);
  }

  static List<ResearchThreadModel> getThreads() {
    threads.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    return List<ResearchThreadModel>.from(threads);
  }

  static List<ResearchMessageModel> getMessages(String researcherName) {
    final id = threadId(researcherName);

    final threadMessages = messages[id] ?? [];

    threadMessages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    return List<ResearchMessageModel>.from(threadMessages);
  }

  static Stream<List<ResearchThreadModel>> watchThreads() {
    Future.microtask(syncThreads);

    return RealtimeMessagingService.threadStream;
  }

  static Stream<List<ResearchMessageModel>> watchMessages(
    String researcherName,
  ) {
    Future.microtask(() => syncMessages(researcherName));

    return RealtimeMessagingService.messageStream(researcherName);
  }

  static void syncThreads() {
    RealtimeMessagingService.notifyThreads(getThreads());

    saveMessages();
  }

  static void syncMessages(String researcherName) {
    RealtimeMessagingService.notifyMessages(
      researcherName: researcherName,
      messages: getMessages(researcherName),
    );

    saveMessages();
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

      final updatedThread = ResearchThreadModel(
        threadId: oldThread.threadId,
        researcherName: oldThread.researcherName,
        university: oldThread.university,
        lastMessage: message,
        updatedAt: now,
        unreadCount: isMe ? oldThread.unreadCount : oldThread.unreadCount + 1,
      );

      threads.removeAt(threadIndex);

      threads.insert(0, updatedThread);
    }

    if (!isMe) {
      NotificationService.addNotification(
        title: "New Research Message",
        body: "$researcherName sent you a message.",
        type: "message",
        targetId: id,
        targetName: researcherName,
        payload: {"researcherName": researcherName, "university": university},
      );
    }

    RealtimeMessagingService.notifyAll(
      threads: getThreads(),
      researcherName: researcherName,
      messages: getMessages(researcherName),
    );

    saveMessages();
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

    syncThreads();
  }

  static int totalUnreadCount() {
    return threads.fold(0, (total, thread) => total + thread.unreadCount);
  }

  static void clearMessages() {
    threads.clear();
    messages.clear();

    RealtimeMessagingService.notifyThreads([]);

    RealtimeMessagingService.disposeAllMessagesOnly();

    saveMessages();
  }
}
