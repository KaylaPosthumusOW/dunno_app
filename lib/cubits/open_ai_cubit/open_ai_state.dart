import 'package:equatable/equatable.dart';
import 'package:dunno/models/collections.dart';
import 'package:dunno/models/filter_suggestion.dart';

abstract class OpenAiState extends Equatable {
  const OpenAiState();

  @override
  List<Object?> get props => [];
}

class OpenAiInitial extends OpenAiState {}

class OpenAiLoading extends OpenAiState {
  final String? loadingMessage;

  const OpenAiLoading({this.loadingMessage});

  @override
  List<Object?> get props => [loadingMessage];
}

class OpenAiGiftSuggestionsLoaded extends OpenAiState {
  final List<GiftSuggestionCard> suggestions;
  final Collections? selectedCollection;
  final FilterSuggestion? appliedFilters;

  const OpenAiGiftSuggestionsLoaded({
    required this.suggestions,
    this.selectedCollection,
    this.appliedFilters,
  });

  @override
  List<Object?> get props => [suggestions, selectedCollection, appliedFilters];
}

class OpenAiError extends OpenAiState {
  final String message;
  final String? errorCode;

  const OpenAiError({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];
}

class OpenAiFiltersApplied extends OpenAiState {
  final Collections? selectedCollection;
  final FilterSuggestion appliedFilters;

  const OpenAiFiltersApplied({
    this.selectedCollection,
    required this.appliedFilters,
  });

  @override
  List<Object?> get props => [selectedCollection, appliedFilters];
}

/// Model for individual gift suggestion cards
class GiftSuggestionCard extends Equatable {
  final String title;
  final String description;
  final String reason;
  final double estimatedPrice;
  final String? imageUrl;
  final String? purchaseLink;
  final List<String> tags;
  final String category;

  const GiftSuggestionCard({
    required this.title,
    required this.description,
    required this.reason,
    required this.estimatedPrice,
    this.imageUrl,
    this.purchaseLink,
    required this.tags,
    required this.category,
  });

  @override
  List<Object?> get props => [
        title,
        description,
        reason,
        estimatedPrice,
        imageUrl,
        purchaseLink,
        tags,
        category,
      ];

  factory GiftSuggestionCard.fromJson(Map<String, dynamic> json) {
    return GiftSuggestionCard(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      reason: json['reason'] ?? '',
      estimatedPrice: (json['estimatedPrice'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'],
      purchaseLink: json['purchaseLink'],
      tags: List<String>.from(json['tags'] ?? []),
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'reason': reason,
      'estimatedPrice': estimatedPrice,
      'imageUrl': imageUrl,
      'purchaseLink': purchaseLink,
      'tags': tags,
      'category': category,
    };
  }
}
