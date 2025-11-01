import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dunno/models/board_gift_suggestion.dart';
import 'package:dunno/models/gift_boards.dart';
import 'package:dunno/stores/gift_board_store.dart';
import 'package:get_it/get_it.dart';

class GiftBoardFirebaseRepository extends GiftBoardStore {
  static final FirebaseFirestore _firebaseFirestore = GetIt.instance<FirebaseFirestore>();

  final CollectionReference<GiftBoard> _giftBoardCollection = _firebaseFirestore.collection('giftBoards').withConverter<GiftBoard>(
    fromFirestore: (snapshot, _) => GiftBoard.fromMap(snapshot.data() ?? {}),
    toFirestore: (map, _) => map.toMap(),
  );

  final CollectionReference<BoardGiftSuggestion> _boardGiftSuggestionCollection = _firebaseFirestore.collection('boardsGiftSuggestions').withConverter<BoardGiftSuggestion>(
    fromFirestore: (snapshot, _) => BoardGiftSuggestion.fromMap(snapshot.data() ?? {}),
    toFirestore: (map, _) => map.toMap(),
  );

  @override
  Future<BoardGiftSuggestion> createBoardGiftSuggestion(BoardGiftSuggestion newBoardGiftSuggestion) async {
    DocumentReference<BoardGiftSuggestion> reference = _boardGiftSuggestionCollection.doc(newBoardGiftSuggestion.uid);
    await reference.set(newBoardGiftSuggestion.copyWith(uid: reference.id), SetOptions(merge: true));
    return newBoardGiftSuggestion.copyWith(uid: reference.id);
  }

  @override
  Future<GiftBoard> createGiftBoard(GiftBoard newGiftBoard) async {
    DocumentReference<GiftBoard> reference = _giftBoardCollection.doc(newGiftBoard.uid);
    await reference.set(newGiftBoard.copyWith(uid: reference.id), SetOptions(merge: true));
    return newGiftBoard.copyWith(uid: reference.id);
  }

  @override
  Future<List<BoardGiftSuggestion>> loadAllBoardGiftSuggestionsForBoard({required String boardUid}) async {
    List<BoardGiftSuggestion> boardGiftSuggestions = [];
    QuerySnapshot<BoardGiftSuggestion> query = await _boardGiftSuggestionCollection.where('board.uid', isEqualTo: boardUid).get();
    for (var doc in query.docs) {
      boardGiftSuggestions.add(doc.data());
    }
    return boardGiftSuggestions;
  }

  @override
  Future<List<GiftBoard>> loadAllGiftBoardsForUser({required String ownerUid}) async {
    List<GiftBoard> giftBoards = [];
    QuerySnapshot<GiftBoard> query = await _giftBoardCollection.where('owner.uid', isEqualTo: ownerUid).get();
    for (var doc in query.docs) {
      giftBoards.add(doc.data());
    }
    return giftBoards;
  }

  @override
  Future<void> updateGiftBoard(GiftBoard giftBoard) async {
    try {
      await _giftBoardCollection.doc(giftBoard.uid).set(giftBoard, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to update gift board: $e');
    }
  }

  @override
  Future<void> deleteBoardGiftSuggestion(String boardGiftSuggestionUid) async {
    await _boardGiftSuggestionCollection.doc(boardGiftSuggestionUid).delete();
  }

  @override
  Future<void> deleteGiftBoard(String giftBoardUid) async {
    await _giftBoardCollection.doc(giftBoardUid).delete();
  }

  @override
  Future<num?> totalGiftSuggestionsForBoard({required String boardUid}) async {
    AggregateQuerySnapshot query = await _boardGiftSuggestionCollection.where('board.uid', isEqualTo: boardUid).count().get();
    return query.count;
  }
}