import 'package:equatable/equatable.dart';
import 'package:dunno/models/ai_gift_suggestion.dart';

/// Base state class for Friend AI gift suggestion flow
abstract class FriendGiftSuggestionState extends Equatable {
  const FriendGiftSuggestionState();

  @override
  List<Object?> get props => [];
}

/// Initial state when no friend suggestions have been requested
class FriendGiftSuggestionInitial extends FriendGiftSuggestionState {
  const FriendGiftSuggestionInitial();

  @override
  String toString() => 'FriendGiftSuggestionInitial';
}

/// Loading state while generating friend suggestions
class FriendGiftSuggestionLoading extends FriendGiftSuggestionState {
  final String message;
  final double? progress;
  final Map<String, dynamic>? profile;
  final Map<String, dynamic>? filters;
  
  const FriendGiftSuggestionLoading({
    this.message = 'Generating gift suggestions for your friend...',
    this.progress,
    this.profile,
    this.filters,
  });

  @override
  List<Object?> get props => [message, progress, profile, filters];

  @override
  String toString() => 'FriendGiftSuggestionLoading(message: $message, progress: $progress)';

  /// Create a copy with updated progress
  FriendGiftSuggestionLoading copyWith({
    String? message,
    double? progress,
    Map<String, dynamic>? profile,
    Map<String, dynamic>? filters,
  }) {
    return FriendGiftSuggestionLoading(
      message: message ?? this.message,
      progress: progress ?? this.progress,
      profile: profile ?? this.profile,
      filters: filters ?? this.filters,
    );
  }
}

/// State when friend suggestions have been successfully loaded
class FriendGiftSuggestionLoaded extends FriendGiftSuggestionState {
  final List<AiGiftSuggestion> suggestions;
  final Map<String, dynamic> profile;
  final Map<String, dynamic> filters;
  
  const FriendGiftSuggestionLoaded({
    required this.suggestions,
    required this.profile,
    required this.filters,
  });

  @override
  List<Object?> get props => [suggestions, profile, filters];

  @override
  String toString() => 'FriendGiftSuggestionLoaded(suggestions: ${suggestions.length} items)';

  /// Create a copy with updated suggestions
  FriendGiftSuggestionLoaded copyWith({
    List<AiGiftSuggestion>? suggestions,
    Map<String, dynamic>? profile,
    Map<String, dynamic>? filters,
  }) {
    return FriendGiftSuggestionLoaded(
      suggestions: suggestions ?? this.suggestions,
      profile: profile ?? this.profile,
      filters: filters ?? this.filters,
    );
  }
}

/// Error state when friend suggestion generation fails
class FriendGiftSuggestionError extends FriendGiftSuggestionState {
  final String message;
  final String? errorCode;
  final Map<String, dynamic> profile;
  final Map<String, dynamic> filters;
  final bool isRetryable;
  
  const FriendGiftSuggestionError({
    required this.message,
    this.errorCode,
    required this.profile,
    required this.filters,
    this.isRetryable = true,
  });

  @override
  List<Object?> get props => [message, errorCode, profile, filters, isRetryable];

  @override
  String toString() => 'FriendGiftSuggestionError(message: $message, errorCode: $errorCode, isRetryable: $isRetryable)';

  /// Create a copy with updated error details
  FriendGiftSuggestionError copyWith({
    String? message,
    String? errorCode,
    Map<String, dynamic>? profile,
    Map<String, dynamic>? filters,
    bool? isRetryable,
  }) {
    return FriendGiftSuggestionError(
      message: message ?? this.message,
      errorCode: errorCode ?? this.errorCode,
      profile: profile ?? this.profile,
      filters: filters ?? this.filters,
      isRetryable: isRetryable ?? this.isRetryable,
    );
  }
}