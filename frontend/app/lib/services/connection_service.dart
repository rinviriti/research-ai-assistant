import '../models/connection_model.dart';
import 'notification_service.dart';

class ConnectionService {
  static final List<ConnectionModel> connections = [];

  static bool isConnected(String researcherName) {
    return connections.any(
      (connection) => connection.researcherName == researcherName,
    );
  }

  static void sendRequest({
    required String researcherName,
    required String university,
  }) {
    if (isConnected(researcherName)) return;

    connections.add(
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
    );
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
    );
  }

  static void removeConnection(String researcherName) {
    connections.removeWhere(
      (connection) => connection.researcherName == researcherName,
    );

    NotificationService.addNotification(
      title: "Connection Removed",
      body: "$researcherName was removed from your research network.",
      type: "connection",
    );
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
}
