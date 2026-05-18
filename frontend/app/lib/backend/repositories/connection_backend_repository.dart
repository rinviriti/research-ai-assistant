import '../../models/connection_model.dart';
import '../../services/connection_service.dart';
import '../mock_backend/mock_database.dart';

class ConnectionBackendRepository {
  Future<List<ConnectionModel>> getConnections() async {
    return ConnectionService.connections;
  }

  Future<void> sendRequest({
    required String researcherName,
    required String university,
  }) async {
    ConnectionService.sendRequest(
      researcherName: researcherName,
      university: university,
    );

    await MockDatabase.addDocument(
      collection: "connections",
      data: {
        "researcherName": researcherName,
        "university": university,
        "status": "pending",
      },
    );
  }

  Future<void> acceptConnection(String researcherName) async {
    ConnectionService.acceptConnection(researcherName);
  }

  Future<void> removeConnection(String researcherName) async {
    ConnectionService.removeConnection(researcherName);
  }

  Future<int> pendingCount() async {
    return ConnectionService.pendingCount();
  }

  Future<int> acceptedCount() async {
    return ConnectionService.acceptedCount();
  }

  Map<String, dynamic> toBackendPayload(ConnectionModel connection) {
    return {
      "researcherName": connection.researcherName,
      "university": connection.university,
      "status": connection.status,
    };
  }

  ConnectionModel fromBackendPayload(Map<String, dynamic> data) {
    return ConnectionModel(
      researcherName: data["researcherName"] ?? "",
      university: data["university"] ?? "",
      status: data["status"] ?? "",
    );
  }
}
