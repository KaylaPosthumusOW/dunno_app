part of 'gift_board_cubit.dart';

class MainGiftBoardState extends Equatable {
  final String? message;
  final String? errorMessage;
  final List<GiftBoard>? allUserGiftBoards;
  final GiftBoard? selectedGiftBoard;
  final num? totalGiftSuggestions;
  final List<GiftBoard>? selectedBoards;

  final List<BoardGiftSuggestion>? allGiftBoardSuggestions;
  final BoardGiftSuggestion? selectedGiftBoardSuggestion;

  const MainGiftBoardState({this.message, this.errorMessage, this.allUserGiftBoards, this.selectedGiftBoard, this.allGiftBoardSuggestions, this.selectedGiftBoardSuggestion, this.totalGiftSuggestions, this.selectedBoards});

  @override
  List<Object?> get props => [message, errorMessage, allUserGiftBoards, selectedGiftBoard, allGiftBoardSuggestions, selectedGiftBoardSuggestion, totalGiftSuggestions, selectedBoards];

  MainGiftBoardState copyWith({
    String? message,
    String? errorMessage,
    List<GiftBoard>? allUserGiftBoards,
    GiftBoard? selectedGiftBoard,
    List<BoardGiftSuggestion>? allGiftBoardSuggestions,
    BoardGiftSuggestion? selectedGiftBoardSuggestion,
    num? totalGiftSuggestions,
    List<GiftBoard>? selectedBoards,
  }) {
    return MainGiftBoardState(
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
      allUserGiftBoards: allUserGiftBoards ?? this.allUserGiftBoards,
      selectedGiftBoard: selectedGiftBoard ?? this.selectedGiftBoard,
      allGiftBoardSuggestions: allGiftBoardSuggestions ?? this.allGiftBoardSuggestions,
      selectedGiftBoardSuggestion: selectedGiftBoardSuggestion ?? this.selectedGiftBoardSuggestion,
      totalGiftSuggestions: totalGiftSuggestions ?? this.totalGiftSuggestions,
      selectedBoards: selectedBoards ?? this.selectedBoards,
    );
  }

  MainGiftBoardState copyWithNull({
    String? message,
    String? errorMessage,
    List<GiftBoard>? allUserGiftBoards,
    GiftBoard? selectedGiftBoard,
    List<BoardGiftSuggestion>? allGiftBoardSuggestions,
    BoardGiftSuggestion? selectedGiftBoardSuggestion,
    num? totalGiftSuggestions,
    List<GiftBoard>? selectedBoards,
  }) {
    return MainGiftBoardState(
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
      allUserGiftBoards: allUserGiftBoards ?? this.allUserGiftBoards,
      selectedGiftBoard: selectedGiftBoard,
      allGiftBoardSuggestions: allGiftBoardSuggestions ?? this.allGiftBoardSuggestions,
      selectedGiftBoardSuggestion: selectedGiftBoardSuggestion,
      totalGiftSuggestions: totalGiftSuggestions ?? this.totalGiftSuggestions,
      selectedBoards: selectedBoards ?? this.selectedBoards,
    );
  }
}

abstract class GiftBoardState extends Equatable {
  final MainGiftBoardState mainGiftBoardState;

  const GiftBoardState(this.mainGiftBoardState);

  @override
  List<Object> get props => [mainGiftBoardState];
}

class GiftBoardInitial extends GiftBoardState {
  const GiftBoardInitial() : super(const MainGiftBoardState());
}

class CreatingGiftBoard extends GiftBoardState {
  const CreatingGiftBoard(super.mainGiftBoardState);
}

class CreatedGiftBoard extends GiftBoardState {
  const CreatedGiftBoard(super.mainGiftBoardState);
}

class CreatingGiftBoardSuggestion extends GiftBoardState {
  const CreatingGiftBoardSuggestion(super.mainGiftBoardState);
}

class CreatedGiftBoardSuggestion extends GiftBoardState {
  const CreatedGiftBoardSuggestion(super.mainGiftBoardState);
}

class LoadingGiftBoards extends GiftBoardState {
  const LoadingGiftBoards(super.mainGiftBoardState);
}

class LoadedGiftBoards extends GiftBoardState {
  const LoadedGiftBoards(super.mainGiftBoardState);
}

class LoadingGiftBoardSuggestion extends GiftBoardState {
  const LoadingGiftBoardSuggestion(super.mainGiftBoardState);
}

class LoadedGiftBoardSuggestion extends GiftBoardState {
  const LoadedGiftBoardSuggestion(super.mainGiftBoardState);
}

class LoadingGiftBoard extends GiftBoardState {
  const LoadingGiftBoard(super.mainGiftBoardState);
}

class SelectedGiftBoard extends GiftBoardState {
  const SelectedGiftBoard(super.mainGiftBoardState);
}

class LoadingGiftBoardSuggestionDetails extends GiftBoardState {
  const LoadingGiftBoardSuggestionDetails(super.mainGiftBoardState);
}

class SelectedGiftBoardSuggestionDetails extends GiftBoardState {
  const SelectedGiftBoardSuggestionDetails(super.mainGiftBoardState);
}

class ToggledGiftBoardSelection extends GiftBoardState {
  const ToggledGiftBoardSelection(super.mainGiftBoardState);
}

class GiftBoardError extends GiftBoardState {
  final String stackTrace;

  const GiftBoardError(super.mainGiftBoardState, {required this.stackTrace});

  @override
  List<Object> get props => [mainGiftBoardState, stackTrace];
}