import '../models/connection_model.dart';

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
  }
}
