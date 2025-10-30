part of 'friend_gift_suggestion_cubit.dart';

/// Holds all friend suggestion domain data.
/// This persists across status state changes.
class MainFriendGiftSuggestionState extends Equatable {
  final String? message;
  final String? errorMessage;

  final List<AiGiftSuggestion>? suggestions;

  /// Optional context for generation
  final Map<String, dynamic>? profile;
  final Map<String, dynamic>? filters;

  /// Optional progress for long-running generation
  final double? progress;

  /// Whether current error is retryable (only meaningful when in an error status)
  final bool? isRetryable;

  const MainFriendGiftSuggestionState({
    this.message,
    this.errorMessage,
    this.suggestions,
    this.profile,
    this.filters,
    this.progress,
    this.isRetryable,
  });

  @override
  List<Object> get props => [
    message ?? '',
    errorMessage ?? '',
    suggestions ?? <AiGiftSuggestion>[],
    profile ?? <String, dynamic>{},
    filters ?? <String, dynamic>{},
    progress ?? 0.0,
    isRetryable ?? false,
  ];

  MainFriendGiftSuggestionState copyWith({
    String? message,
    String? errorMessage,
    List<AiGiftSuggestion>? suggestions,
    Map<String, dynamic>? profile,
    Map<String, dynamic>? filters,
    double? progress,
    bool? isRetryable,
  }) {
    return MainFriendGiftSuggestionState(
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
      suggestions: suggestions ?? this.suggestions,
      profile: profile ?? this.profile,
      filters: filters ?? this.filters,
      progress: progress ?? this.progress,
      isRetryable: isRetryable ?? this.isRetryable,
    );
  }

  /// Same as copyWith, but lets you explicitly null-out selected fields.
  MainFriendGiftSuggestionState copyWithNull({
    String? message,
    String? errorMessage,
    List<AiGiftSuggestion>? suggestions,
    Map<String, dynamic>? profile,
    Map<String, dynamic>? filters,
    double? progress,
    bool? isRetryable,
  }) {
    return MainFriendGiftSuggestionState(
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
      suggestions: suggestions, // explicit null allowed
      profile: profile,         // explicit null allowed
      filters: filters,         // explicit null allowed
      progress: progress,       // explicit null allowed
      isRetryable: isRetryable, // explicit null allowed
    );
  }
}

/// Base status class that carries the shared main state.
abstract class FriendGiftSuggestionState extends Equatable {
  final MainFriendGiftSuggestionState main;

  const FriendGiftSuggestionState(this.main);

  @override
  List<Object> get props => [main];
}

/// Initial status (no generation requested yet)
class FriendGiftSuggestionInitial extends FriendGiftSuggestionState {
  const FriendGiftSuggestionInitial()
      : super(const MainFriendGiftSuggestionState());

  @override
  String toString() => 'FriendGiftSuggestionInitial';
}

/// Loading/generating status (progress may be present in `main.progress`)
class FriendGiftSuggestionLoading extends FriendGiftSuggestionState {
  const FriendGiftSuggestionLoading(super.main);

  @override
  String toString() =>
      'FriendGiftSuggestionLoading(progress: ${main.progress}, message: ${main.message})';
}

/// Loaded status with suggestions in `main.suggestions`
class FriendGiftSuggestionLoaded extends FriendGiftSuggestionState {
  const FriendGiftSuggestionLoaded(super.main);

  @override
  String toString() =>
      'FriendGiftSuggestionLoaded(suggestions: ${main.suggestions?.length ?? 0})';
}

/// Error status; data is in `main.errorMessage` and optional extra fields below.
class FriendGiftSuggestionError extends FriendGiftSuggestionState {
  final String? errorCode;
  final String? stackTraceString;

  const FriendGiftSuggestionError(
      super.main, {
        this.errorCode,
        this.stackTraceString,
      });

  @override
  List<Object> get props => [main, errorCode ?? '', stackTraceString ?? ''];

  @override
  String toString() =>
      'FriendGiftSuggestionError(message: ${main.errorMessage}, errorCode: $errorCode, retryable: ${main.isRetryable})';
}
