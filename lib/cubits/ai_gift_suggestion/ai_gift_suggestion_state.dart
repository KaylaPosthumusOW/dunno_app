import 'package:equatable/equatable.dart';
import 'package:dunno/models/ai_gift_suggestion.dart';

/// Base state class for AI gift suggestion flow
abstract class AiGiftSuggestionState extends Equatable {
  const AiGiftSuggestionState();

  @override
  List<Object?> get props => [];
}

/// Initial state when no suggestions have been requested
class AiGiftSuggestionInitial extends AiGiftSuggestionState {
  const AiGiftSuggestionInitial();

  @override
  String toString() => 'AiGiftSuggestionInitial';
}

/// Loading state while generating suggestions
class AiGiftSuggestionLoading extends AiGiftSuggestionState {
  final String message;
  final double? progress;
  final Map<String, dynamic>? profile;
  final Map<String, dynamic>? filters;
  
  const AiGiftSuggestionLoading({
    this.message = 'Generating personalised gift suggestions...',
    this.progress,
    this.profile,
    this.filters,
  });

  @override
  List<Object?> get props => [message, progress, profile, filters];

  @override
  String toString() => 'AiGiftSuggestionLoading(message: $message, progress: $progress)';

  /// Create a copy with updated progress
  AiGiftSuggestionLoading copyWith({
    String? message,
    double? progress,
    Map<String, dynamic>? profile,
    Map<String, dynamic>? filters,
  }) {
    return AiGiftSuggestionLoading(
      message: message ?? this.message,
      progress: progress ?? this.progress,
      profile: profile ?? this.profile,
      filters: filters ?? this.filters,
    );
  }
}

/// Success state with generated suggestions
class AiGiftSuggestionLoaded extends AiGiftSuggestionState {
  final List<AiGiftSuggestion> suggestions;
  final Map<String, dynamic> profile;
  final Map<String, dynamic> filters;
  final DateTime generatedAt;
  
  AiGiftSuggestionLoaded({
    required this.suggestions,
    required this.profile,
    required this.filters,
    DateTime? generatedAt,
  }) : generatedAt = generatedAt ?? DateTime.now();

  @override
  List<Object?> get props => [suggestions, profile, filters, generatedAt];

  @override
  String toString() => 'AiGiftSuggestionLoaded(suggestions: ${suggestions.length} items, generatedAt: $generatedAt)';

  /// Get suggestion by index safely
  AiGiftSuggestion? getSuggestionAt(int index) {
    if (index >= 0 && index < suggestions.length) {
      return suggestions[index];
    }
    return null;
  }

  /// Check if suggestions are fresh (generated within last 5 minutes)
  bool get isFresh {
    return DateTime.now().difference(generatedAt).inMinutes < 5;
  }
}

/// Error state when suggestion generation fails
class AiGiftSuggestionError extends AiGiftSuggestionState {
  final String message;
  final String? errorCode;
  final String? technicalDetails;
  final Map<String, dynamic>? profile;
  final Map<String, dynamic>? filters;
  final DateTime errorTime;
  final bool isRetryable;
  
  AiGiftSuggestionError({
    required this.message,
    this.errorCode,
    this.technicalDetails,
    this.profile,
    this.filters,
    DateTime? errorTime,
    this.isRetryable = true,
  }) : errorTime = errorTime ?? DateTime.now();

  @override
  List<Object?> get props => [
    message, 
    errorCode, 
    technicalDetails, 
    profile, 
    filters, 
    errorTime, 
    isRetryable
  ];

  @override
  String toString() => 'AiGiftSuggestionError(message: $message, errorCode: $errorCode, isRetryable: $isRetryable)';

  /// Get user-friendly error message based on error code
  String get userFriendlyMessage {
    switch (errorCode) {
      case 'API_KEY_ERROR':
        return 'Configuration error. Please contact support.';
      case 'NETWORK_ERROR':
        return 'Connection failed. Please check your internet and try again.';
      case 'TIMEOUT_ERROR':
        return 'Request timed out. Please try again.';
      case 'PARSE_ERROR':
        return 'Invalid response received. Please try again.';
      case 'RATE_LIMIT_ERROR':
        return 'Too many requests. Please wait a moment and try again.';
      case 'VALIDATION_ERROR':
        return 'Please check your input and try again.';
      default:
        return message;
    }
  }
}