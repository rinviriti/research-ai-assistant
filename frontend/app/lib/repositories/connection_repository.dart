import '../models/connection_model.dart';
import '../services/connection_service.dart';

class ConnectionRepository {
  Future<List<ConnectionModel>> getConnections() async {
    return ConnectionService.connections;
  }

  Future<void> connect({
    required String researcherName,
    required String university,
  }) async {
    ConnectionService.sendRequest(
      researcherName: researcherName,
      university: university,
    );
  }
}
