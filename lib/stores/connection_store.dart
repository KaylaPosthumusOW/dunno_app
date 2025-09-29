import 'package:dunno/models/connections.dart';

abstract class ConnectionStore {
  Future<Connection> createConnection(Connection newConnection);
  Future<List<Connection>> loadAllConnectionsForUser({required String userUid});
  Future<num?> countConnectionsForUser({required String userUid});
  Future<void> updateConnection(Connection connection);
  Future<void> deleteConnection(String connectionUid);
}