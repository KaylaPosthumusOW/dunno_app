import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dunno/stores/main_firebase_store.dart';
import 'package:get_it/get_it.dart';

class MainFirebaseRepository extends MainFirebaseStore {
  static final FirebaseFirestore _firebaseFirestore = GetIt.instance<FirebaseFirestore>();

  final CollectionReference<Map<String, dynamic>?> _settingsCollection = _firebaseFirestore.collection('settings').withConverter<Map<String, dynamic>?>(
        fromFirestore: (snapshot, _) => snapshot.data()!,
        toFirestore: (map, _) => map as Map<String, dynamic>,
      );

  @override
  Future<int> latestAppVersion() async {
    DocumentSnapshot<Map<String, dynamic>?> snapshot = await _settingsCollection.doc('latestAppVersion').get();
    if (snapshot.exists && snapshot.data()!['build'] != null) {
      return snapshot.data()!['build'];
    }
    return 0;
  }
}
