import 'package:dunno/models/board_gift_suggestion.dart';
import 'package:dunno/models/gift_boards.dart';

abstract class GiftBoardStore {
  Future<GiftBoard> createGiftBoard(GiftBoard newGiftBoard);
  Future<void> updateGiftBoard(GiftBoard giftBoard);
  Future<List<GiftBoard>> loadAllGiftBoardsForUser({required String ownerUid});
  Future<void> deleteGiftBoard(String giftBoardUid);

  Future<BoardGiftSuggestion> createBoardGiftSuggestion(BoardGiftSuggestion newBoardGiftSuggestion);
  Future<List<BoardGiftSuggestion>> loadAllBoardGiftSuggestionsForBoard({required String boardUid});
  Future<void> deleteBoardGiftSuggestion(String boardGiftSuggestionUid);
}