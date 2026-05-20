import 'dart:async';

import '../models/research_message_model.dart';
import '../models/research_thread_model.dart';

class RealtimeMessagingService {
  static final StreamController<List<ResearchThreadModel>> _threadController =
      StreamController<List<ResearchThreadModel>>.broadcast();

  static final Map<String, StreamController<List<ResearchMessageModel>>>
  _messageControllers = {};

  static String threadId(String researcherName) {
    return researcherName.trim().toLowerCase().replaceAll(" ", "_");
  }

  static Stream<List<ResearchThreadModel>> get threadStream {
    return _threadController.stream;
  }

  static Stream<List<ResearchMessageModel>> messageStream(
    String researcherName,
  ) {
    final id = threadId(researcherName);

    _messageControllers.putIfAbsent(
      id,
      () => StreamController<List<ResearchMessageModel>>.broadcast(),
    );

    return _messageControllers[id]!.stream;
  }

  static void notifyThreads(List<ResearchThreadModel> threads) {
    if (!_threadController.isClosed) {
      _threadController.add(List<ResearchThreadModel>.from(threads));
    }
  }

  static void notifyMessages({
    required String researcherName,
    required List<ResearchMessageModel> messages,
  }) {
    final id = threadId(researcherName);

    _messageControllers.putIfAbsent(
      id,
      () => StreamController<List<ResearchMessageModel>>.broadcast(),
    );

    if (!_messageControllers[id]!.isClosed) {
      _messageControllers[id]!.add(List<ResearchMessageModel>.from(messages));
    }
  }

  static void notifyAll({
    required List<ResearchThreadModel> threads,
    required String researcherName,
    required List<ResearchMessageModel> messages,
  }) {
    notifyThreads(threads);
    notifyMessages(researcherName: researcherName, messages: messages);
  }

  static void disposeAllMessagesOnly() {
    for (final controller in _messageControllers.values) {
      controller.close();
    }

    _messageControllers.clear();
  }
}
