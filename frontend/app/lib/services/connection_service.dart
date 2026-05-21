import 'dart:async';

import '../models/connection_model.dart';
import 'notification_service.dart';

class ConnectionService {
  static final List<ConnectionModel> connections = [];

  static final StreamController<List<ConnectionModel>> _controller =
      StreamController<List<ConnectionModel>>.broadcast();

  static Stream<List<ConnectionModel>> get stream {
    Future.microtask(sync);
    return _controller.stream;
  }

  static void sync() {
    if (!_controller.isClosed) {
      _controller.add(List<ConnectionModel>.from(connections));
    }
  }

  static List<ConnectionModel> getConnections() {
    return List<ConnectionModel>.from(connections);
  }

  static bool isConnected(String researcherName) {
    return connections.any(
      (connection) => connection.researcherName == researcherName,
    );
  }

  static bool isAccepted(String researcherName) {
    return connections.any(
      (connection) =>
          connection.researcherName == researcherName &&
          connection.status == "accepted",
    );
  }

  static bool isPending(String researcherName) {
    return connections.any(
      (connection) =>
          connection.researcherName == researcherName &&
          connection.status == "pending",
    );
  }

  static ConnectionModel? getConnection(String researcherName) {
    try {
      return connections.firstWhere(
        (connection) => connection.researcherName == researcherName,
      );
    } catch (_) {
      return null;
    }
  }

  static void sendRequest({
    required String researcherName,
    required String university,
    List<String> interests = const [],
  }) {
    if (isConnected(researcherName)) return;

    connections.insert(
      0,
      ConnectionModel(
        researcherName: researcherName,
        university: university,
        status: "pending",
      ),
    );

    NotificationService.addNotification(
      title: "Connection Request Sent",
      body: "You sent a research connection request to $researcherName.",
      type: "connection",
      targetName: researcherName,
      payload: {
        "researcherName": researcherName,
        "university": university,
        "interests": interests,
      },
    );

    sync();
  }

  static void acceptConnection(String researcherName) {
    final index = connections.indexWhere(
      (connection) => connection.researcherName == researcherName,
    );

    if (index == -1) return;

    final oldConnection = connections[index];

    connections[index] = ConnectionModel(
      researcherName: oldConnection.researcherName,
      university: oldConnection.university,
      status: "accepted",
    );

    NotificationService.addNotification(
      title: "Connection Accepted",
      body: "$researcherName is now part of your research network.",
      type: "connection",
      targetName: oldConnection.researcherName,
      payload: {
        "researcherName": oldConnection.researcherName,
        "university": oldConnection.university,
        "interests": <String>[],
      },
    );

    sync();
  }

  static void removeConnection(String researcherName) {
    final oldConnection = getConnection(researcherName);

    connections.removeWhere(
      (connection) => connection.researcherName == researcherName,
    );

    NotificationService.addNotification(
      title: "Connection Removed",
      body: "$researcherName was removed from your research network.",
      type: "connection",
      targetName: researcherName,
      payload: {
        "researcherName": researcherName,
        "university": oldConnection?.university ?? "Research Network",
        "interests": <String>[],
      },
    );

    sync();
  }

  static int pendingCount() {
    return connections
        .where((connection) => connection.status == "pending")
        .length;
  }

  static int acceptedCount() {
    return connections
        .where((connection) => connection.status == "accepted")
        .length;
  }

  static void clearConnections() {
    connections.clear();
    sync();
  }
}
