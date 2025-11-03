import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dunno/constants/constants.dart';
import 'package:dunno/models/board_gift_suggestion.dart';
import 'package:dunno/models/gift_boards.dart';
import 'package:dunno/stores/firebase/gift_board_firebase_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'gift_board_state.dart';

class GiftBoardCubit extends Cubit<GiftBoardState> {
  final GiftBoardFirebaseRepository _giftBoardFirebaseRepository = sl<GiftBoardFirebaseRepository>();

  GiftBoardCubit() : super(const GiftBoardInitial());

  Future<void> createNewBoard(GiftBoard newGiftBoard) async {
    emit(CreatingGiftBoard(state.mainGiftBoardState.copyWith(message: 'Creating new gift board')));
    try {
      List<GiftBoard> giftBoards = List.from(state.mainGiftBoardState.allUserGiftBoards ?? []);
      GiftBoard giftBoard = await _giftBoardFirebaseRepository.createGiftBoard(newGiftBoard);
      giftBoards.add(giftBoard);
      emit(CreatedGiftBoard(state.mainGiftBoardState.copyWith(allUserGiftBoards: giftBoards, message: 'Created new gift board')));
    } catch (error, stackTrace) {
      emit(
        GiftBoardError(
          state.mainGiftBoardState.copyWith(message: '', errorMessage: error.toString()),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
  }

  Future<void> loadAllUserGiftBoards({required String ownerUid}) async {
    emit(LoadingGiftBoards(state.mainGiftBoardState.copyWith(message: 'Loading gift boards')));
    try {
      List<GiftBoard> giftBoards = await _giftBoardFirebaseRepository.loadAllGiftBoardsForUser(ownerUid: ownerUid);
      emit(LoadedGiftBoards(state.mainGiftBoardState.copyWith(allUserGiftBoards: giftBoards, message: 'Loaded ${giftBoards.length} gift boards')));
    } catch (error, stackTrace) {
      emit(
        GiftBoardError(
          state.mainGiftBoardState.copyWith(message: '', errorMessage: error.toString()),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
  }

  Future<void> selectGiftBoard(GiftBoard giftBoard) async {
    emit(LoadingGiftBoard(state.mainGiftBoardState.copyWith(message: 'Selecting gift board')));
    emit(SelectedGiftBoard(state.mainGiftBoardState.copyWith(selectedGiftBoard: giftBoard, message: 'Selected gift board')));
  }

  clearSelectedGiftBoard() {
    emit(LoadingGiftBoard(state.mainGiftBoardState.copyWith(message: 'Clearing selected gift board')));
    emit(SelectedGiftBoard(state.mainGiftBoardState.copyWithNull(message: 'Cleared selected gift board')));
  }

  Future<void> createNewBoardGiftSuggestion(BoardGiftSuggestion newBoardGiftSuggestion) async {
    emit(CreatingGiftBoardSuggestion(state.mainGiftBoardState.copyWith(message: 'Creating new gift board suggestion')));
    try {
      List<BoardGiftSuggestion> boardGiftSuggestions = List.from(state.mainGiftBoardState.allGiftBoardSuggestions ?? []);
      BoardGiftSuggestion boardGiftSuggestion = await _giftBoardFirebaseRepository.createBoardGiftSuggestion(newBoardGiftSuggestion);
      boardGiftSuggestions.add(boardGiftSuggestion);
      emit(CreatedGiftBoardSuggestion(state.mainGiftBoardState.copyWith(allGiftBoardSuggestions: boardGiftSuggestions, message: 'Created new gift board suggestion')));
    } catch (error, stackTrace) {
      emit(
        GiftBoardError(
          state.mainGiftBoardState.copyWith(message: '', errorMessage: error.toString()),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
  }

  Future<void> loadAllBoardGiftSuggestionsForBoard({required String boardUid}) async {
    emit(LoadingGiftBoardSuggestion(state.mainGiftBoardState.copyWith(message: 'Loading gift board suggestions')));
    try {
      List<BoardGiftSuggestion> boardGiftSuggestions = await _giftBoardFirebaseRepository.loadAllBoardGiftSuggestionsForBoard(boardUid: boardUid);
      emit(LoadedGiftBoardSuggestion(state.mainGiftBoardState.copyWith(allGiftBoardSuggestions: boardGiftSuggestions, message: 'Loaded ${boardGiftSuggestions.length} gift board suggestions')));
    } catch (error, stackTrace) {
      emit(
        GiftBoardError(
          state.mainGiftBoardState.copyWith(message: '', errorMessage: error.toString()),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
  }

  selectGiftBoardSuggestion(BoardGiftSuggestion boardGiftSuggestion) {
    emit(LoadingGiftBoardSuggestionDetails(state.mainGiftBoardState.copyWith(message: 'Selected gift board suggestion')));
    emit(SelectedGiftBoardSuggestionDetails(state.mainGiftBoardState.copyWith(selectedGiftBoardSuggestion: boardGiftSuggestion, message: 'Selected gift board suggestion')));
  }

  toggleBoardSelection(GiftBoard board) {
    final current = List<GiftBoard>.from(state.mainGiftBoardState.selectedBoards ?? []);

    if (current.any((b) => b.uid == board.uid)) {
      current.removeWhere((b) => b.uid == board.uid);
    } else {
      current.add(board);
    }
    emit(ToggledGiftBoardSelection(state.mainGiftBoardState.copyWith(selectedBoards: current, message: 'Toggled gift board selection', errorMessage: '')));
  }

  clearBoardSelections() {
    emit(ToggledGiftBoardSelection(state.mainGiftBoardState.copyWithNull(message: 'Cleared gift board selections', errorMessage: '')));
  }

  Future<void> saveBoardSuggestions() async {
    emit(CreatingGiftBoardSuggestion(state.mainGiftBoardState.copyWith(message: 'Saving gift board suggestions')));
    try {
      final selectedBoards = state.mainGiftBoardState.selectedBoards ?? [];
      final selectedSuggestion = state.mainGiftBoardState.selectedGiftBoardSuggestion;
      if (selectedSuggestion == null) {
        throw Exception('No gift board suggestion selected');
      }

      for (final board in selectedBoards) {
        await _giftBoardFirebaseRepository.createBoardGiftSuggestion(
          BoardGiftSuggestion(
            board: board,
            createdAt: Timestamp.now(),
            giftSuggestion: selectedSuggestion.giftSuggestion,
          ),
        );
      }

      emit(CreatedGiftBoardSuggestion(state.mainGiftBoardState.copyWith(message: 'Saved gift board suggestions')));
    } catch (error, stackTrace) {
      emit(
        GiftBoardError(
          state.mainGiftBoardState.copyWith(message: '', errorMessage: error.toString()),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
  }

  Future<void> deleteGiftBoard({required String boardUid}) async {
    emit(DeletingGiftBoard(state.mainGiftBoardState.copyWith(message: 'Deleting gift board')));
    try {
      List<GiftBoard> allGiftBoards = state.mainGiftBoardState.allUserGiftBoards ?? [];
      await _giftBoardFirebaseRepository.deleteGiftBoard(boardUid);
      allGiftBoards.removeWhere((e) => e.uid == boardUid);
      emit(DeletedGiftBoard(state.mainGiftBoardState.copyWith(allUserGiftBoards: allGiftBoards, message: 'Gift board deleted successfully')));
    } catch (error, stackTrace) {
      emit(
        GiftBoardError(
          state.mainGiftBoardState.copyWith(message: '', errorMessage: error.toString()),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
  }


}
