import 'dart:async';

import '../models/research_message_model.dart';
import 'research_messaging_service.dart';

class RealtimeMessagingService {
  static final Map<String, StreamController<List<ResearchMessageModel>>>
  _controllers = {};

  static String threadId(String researcherName) {
    return researcherName.trim().toLowerCase().replaceAll(" ", "_");
  }

  static Stream<List<ResearchMessageModel>> messageStream(
    String researcherName,
  ) {
    final id = threadId(researcherName);

    _controllers.putIfAbsent(
      id,
      () => StreamController<List<ResearchMessageModel>>.broadcast(),
    );

    Future.microtask(() {
      _controllers[id]?.add(
        ResearchMessagingService.getMessages(researcherName),
      );
    });

    return _controllers[id]!.stream;
  }

  static void notifyThread(String researcherName) {
    final id = threadId(researcherName);

    _controllers.putIfAbsent(
      id,
      () => StreamController<List<ResearchMessageModel>>.broadcast(),
    );

    _controllers[id]?.add(ResearchMessagingService.getMessages(researcherName));
  }

  static void disposeThread(String researcherName) {
    final id = threadId(researcherName);
    _controllers[id]?.close();
    _controllers.remove(id);
  }

  static void disposeAll() {
    for (final controller in _controllers.values) {
      controller.close();
    }

    _controllers.clear();
  }
}
