part of 'collection_cubit.dart';

class MainCollectionState extends Equatable {
  final String? message;
  final String? errorMessage;
  final List<Collections>? allUserCollections;
  final Collections? selectedCollection;

  const MainCollectionState({this.message, this.errorMessage, this.allUserCollections, this.selectedCollection});

  @override
  List<Object?> get props => [message, errorMessage, allUserCollections, selectedCollection];

  MainCollectionState copyWith({
    String? message,
    String? errorMessage,
    List<Collections>? allUserCollections,
    Collections? selectedCollection,
  }) {
    return MainCollectionState(
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
      allUserCollections: allUserCollections ?? this.allUserCollections,
      selectedCollection: selectedCollection ?? this.selectedCollection,
    );
  }

  MainCollectionState copyWithNull({
    String? message,
    String? errorMessage,
    List<Collections>? allUserCollections,
    Collections? selectedCollection,
  }) {
    return MainCollectionState(
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
      allUserCollections: allUserCollections ?? this.allUserCollections,
      selectedCollection: selectedCollection,
    );
  }
}

abstract class CollectionState extends Equatable {
  final MainCollectionState mainCollectionState;

  const CollectionState(this.mainCollectionState);

  @override
  List<Object> get props => [mainCollectionState];
}

class CollectionInitial extends CollectionState {
  const CollectionInitial() : super(const MainCollectionState());
}

class LoadingAllCollections extends CollectionState {
  const LoadingAllCollections(super.mainCollectionState);
}

class LoadedAllCollections extends CollectionState {
  const LoadedAllCollections(super.mainCollectionState);
}

class CreatingCollection extends CollectionState {
  const CreatingCollection(super.mainCollectionState);
}

class CreatedCollection extends CollectionState {
  const CreatedCollection(super.mainCollectionState);
}

class UpdatingCollection extends CollectionState {
  const UpdatingCollection(super.mainCollectionState);
}

class UpdatedCollection extends CollectionState {
  const UpdatedCollection(super.mainCollectionState);
}

class SelectedCollection extends CollectionState {
  const SelectedCollection(super.mainCollectionState);
}

class CollectionError extends CollectionState {
  final String stackTrace;

  const CollectionError(super.mainCollectionState, {required this.stackTrace});

  @override
  List<Object> get props => [mainCollectionState, stackTrace];
}