import 'package:equatable/equatable.dart';
import 'package:dunno/models/collections.dart';
import 'package:dunno/models/filter_suggestion.dart';
import 'package:dunno/models/ai_gift_suggestion.dart';

abstract class OpenAiState extends Equatable {
  const OpenAiState();

  @override
  List<Object?> get props => [];
}

/// Initial state - no collection or filters selected
class OpenAiInitial extends OpenAiState {
  const OpenAiInitial();
}

/// Collection has been selected but no filters applied yet
class OpenAiCollectionSelected extends OpenAiState {
  final Collections selectedCollection;

  const OpenAiCollectionSelected({
    required this.selectedCollection,
  });

  @override
  List<Object?> get props => [selectedCollection];
}

/// Filters have been applied, ready to generate suggestions
class OpenAiFiltersApplied extends OpenAiState {
  final Collections selectedCollection;
  final FilterSuggestion appliedFilters;

  const OpenAiFiltersApplied({
    required this.selectedCollection,
    required this.appliedFilters,
  });

  @override
  List<Object?> get props => [selectedCollection, appliedFilters];
}

/// Currently generating suggestions
class OpenAiGenerating extends OpenAiState {
  final Collections selectedCollection;
  final FilterSuggestion? appliedFilters;
  final String loadingMessage;

  const OpenAiGenerating({
    required this.selectedCollection,
    this.appliedFilters,
    this.loadingMessage = 'Generating gift suggestions...',
  });

  @override
  List<Object?> get props => [selectedCollection, appliedFilters, loadingMessage];
}

/// Suggestions have been successfully generated
class OpenAiSuggestionsLoaded extends OpenAiState {
  final List<AiGiftSuggestion> suggestions;
  final Collections selectedCollection;
  final FilterSuggestion? appliedFilters;

  const OpenAiSuggestionsLoaded({
    required this.suggestions,
    required this.selectedCollection,
    this.appliedFilters,
  });

  @override
  List<Object?> get props => [suggestions, selectedCollection, appliedFilters];
}

/// Error occurred during any operation
class OpenAiError extends OpenAiState {
  final String message;
  final String? errorCode;
  final Collections? selectedCollection;
  final FilterSuggestion? appliedFilters;

  const OpenAiError({
    required this.message,
    this.errorCode,
    this.selectedCollection,
    this.appliedFilters,
  });

  @override
  List<Object?> get props => [message, errorCode, selectedCollection, appliedFilters];
}

