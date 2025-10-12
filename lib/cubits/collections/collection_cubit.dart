import 'package:dunno/constants/constants.dart';
import 'package:dunno/models/collections.dart';
import 'package:dunno/stores/firebase/collection_firebase_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'collection_state.dart';

class CollectionCubit extends Cubit<CollectionState> {
  final CollectionFirebaseRepository _collectionFirebaseRepository = sl<CollectionFirebaseRepository>();

  CollectionCubit() : super(const CollectionInitial());

  Future<void> loadAllCollectionsForUser({required String userUid}) async {
    emit(LoadingAllCollections(state.mainCollectionState.copyWith(message: 'Loading collections')));
    try {
      List<Collections> collections = await _collectionFirebaseRepository.loadAllCollectionsForUser(userUid: userUid);
      emit(LoadedAllCollections(state.mainCollectionState.copyWith(allUserCollections: collections, message: 'Loaded ${collections.length} collections')));
    } catch (error, stackTrace) {
      emit(CollectionError(state.mainCollectionState.copyWith(message: '', errorMessage: error.toString()), stackTrace: stackTrace.toString()));
    }
  }

  Future<void> createNewCollection(Collections newCollection) async {
    emit(CreatingCollection(state.mainCollectionState.copyWith(message: 'Adding new collection')));
    try {
      List<Collections> collectionsList = List.from(state.mainCollectionState.allUserCollections ?? []);
      Collections? collection = await _collectionFirebaseRepository.createCollection(newCollection);
      collectionsList.add(collection);
      emit(CreatedCollection(state.mainCollectionState.copyWith(allUserCollections: collectionsList, message: 'New collection added', errorMessage: '')));
    } catch (error, stackTrace) {
      emit(CollectionError(state.mainCollectionState.copyWith(message: '', errorMessage: error.toString()), stackTrace: stackTrace.toString()));
    }
  }

  Future<void> updateCollection(Collections collection) async {
    emit(UpdatingCollection(state.mainCollectionState.copyWith(message: 'Updating collection')));
    try {
      await _collectionFirebaseRepository.updateCollection(collection);
      List<Collections> collectionsList = List.from(state.mainCollectionState.allUserCollections ?? []);
      int index = collectionsList.indexWhere((c) => c.uid == collection.uid);
      if (index != -1) {
        collectionsList[index] = collection;
      }

      Collections? selected = state.mainCollectionState.selectedCollection;
      if (selected != null && selected.uid == collection.uid) {
        selected = collection;
      }

      emit(UpdatedCollection(state.mainCollectionState.copyWith(allUserCollections: collectionsList, selectedCollection: selected, message: 'Collection updated', errorMessage: '')));
    } catch (error, stackTrace) {
      emit(CollectionError(state.mainCollectionState.copyWith(message: '', errorMessage: error.toString()), stackTrace: stackTrace.toString()));
    }
  }

  Future<void> deleteCollection(String collectionUid) async {
    emit(UpdatingCollection(state.mainCollectionState.copyWith(message: 'Deleting collection')));
    try {
      await _collectionFirebaseRepository.deleteCollection(collectionUid);
      List<Collections> collectionsList = List.from(state.mainCollectionState.allUserCollections ?? []);
      collectionsList.removeWhere((c) => c.uid == collectionUid);
      emit(UpdatedCollection(state.mainCollectionState.copyWith(allUserCollections: collectionsList, message: 'Collection deleted', errorMessage: '')));
    } catch (error, stackTrace) {
      emit(CollectionError(state.mainCollectionState.copyWith(message: '', errorMessage: error.toString()), stackTrace: stackTrace.toString()));
    }
  }

  void setSelectedCollection(Collections collection) {
    emit(LoadingAllCollections(state.mainCollectionState.copyWith(message: 'Selecting collection')));
    emit(SelectedCollection(state.mainCollectionState.copyWith(selectedCollection: collection, message: 'Collection selected', errorMessage: '')));
  }
}