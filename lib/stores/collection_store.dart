import 'package:dunno/models/collections.dart';

abstract class CollectionStore {
  Future<Collections> createCollection(Collections newCollection);
  Future<List<Collections>> loadAllCollectionsForUser({required String userUid});
  Future<void> updateCollection(Collections collection);
  Future<void> deleteCollection(String collectionUid);
}