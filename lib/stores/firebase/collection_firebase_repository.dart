import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dunno/models/collections.dart';
import 'package:dunno/stores/collection_store.dart';
import 'package:get_it/get_it.dart';

class CollectionFirebaseRepository implements CollectionStore {
  static final FirebaseFirestore _firebaseFirestore = GetIt.instance<FirebaseFirestore>();

  final CollectionReference<Collections> _collectionCollection = _firebaseFirestore.collection('collections').withConverter<Collections>(
    fromFirestore: (snapshot, _) => Collections.fromMap(snapshot.data() ?? {}),
    toFirestore: (map, _) => map.toMap(),
  );

  @override
  Future<Collections> createCollection(Collections newCollection) async {
    DocumentReference<Collections> reference = _collectionCollection.doc(newCollection.uid);
    await reference.set(newCollection.copyWith(uid: reference.id), SetOptions(merge: true));
    return newCollection.copyWith(uid: reference.id);
  }

  @override
  Future<List<Collections>> loadAllCollectionsForUser({required String userUid}) async {
    List<Collections> collections = [];
    QuerySnapshot<Collections> query = await _collectionCollection.where('owner.uid', isEqualTo: userUid).orderBy('createdAt', descending: true).get();
    for (var doc in query.docs) {
      collections.add(doc.data());
    }
    return collections;
  }

  @override
  Future<Collections> updateCollection(Collections collection) async {
    try {
      await _collectionCollection.doc(collection.uid).set(collection, SetOptions(merge: true));
      return collection;
    } catch (e) {
      throw Exception('Failed to update collection: $e');
    }
  }

  @override
  Future<void> deleteCollection(String collectionUid) async {
    try {
      await _collectionCollection.doc(collectionUid).delete();
    } catch (e) {
      throw Exception('Failed to delete collection: $e');
    }
  }


}