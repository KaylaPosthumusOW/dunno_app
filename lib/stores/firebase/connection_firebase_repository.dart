import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dunno/models/connections.dart';
import 'package:dunno/stores/connection_store.dart';
import 'package:get_it/get_it.dart';

class ConnectionFirebaseRepository extends ConnectionStore {
  static final FirebaseFirestore _firebaseFirestore = GetIt.instance<FirebaseFirestore>();

  final CollectionReference<Connection> _connectionCollection = _firebaseFirestore.collection('connections').withConverter<Connection>(
    fromFirestore: (snapshot, _) => Connection.fromMap(snapshot.data() ?? {}),
    toFirestore: (map, _) => map.toMap(),
  );

  @override
  Future<Connection> createConnection(Connection newConnection) async {
    DocumentReference<Connection> reference = _connectionCollection.doc(newConnection.uid);
    await reference.set(newConnection.copyWith(uid: reference.id), SetOptions(merge: true));
    return newConnection.copyWith(uid: reference.id);
  }

  @override
  Future<List<Connection>> loadAllConnectionsForUser({required String userUid}) async {
    List<Connection> connections = [];
    QuerySnapshot<Connection> query = await _connectionCollection.where('user.uid', isEqualTo: userUid).orderBy('createdAt', descending: true).get();
    for (var doc in query.docs) {
      connections.add(doc.data());
    }
    return connections;
  }

  @override
  Future<void> updateConnection(Connection connection) async {
    try {
      await _connectionCollection.doc(connection.uid).set(connection, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to update connection: $e');
    }
  }

  @override
  Future<void> deleteConnection(String connectionUid) async {
    try {
      await _connectionCollection.doc(connectionUid).delete();
    } catch (e) {
      throw Exception('Failed to delete connection: $e');
    }
  }

  @override
  Future<num?> countConnectionsForUser({required String userUid}) async {
    AggregateQuerySnapshot query = await _connectionCollection.where('user.uid', isEqualTo: userUid).count().get();
    return query.count;
  }

}