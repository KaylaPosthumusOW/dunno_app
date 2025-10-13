import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dunno/repositories/ai_text_generation_repository.dart';
import 'package:dunno/models/ai_gift_suggestion.dart';
import 'ai_gift_suggestion_state.dart';

class AiGiftSuggestionCubit extends Cubit<AiGiftSuggestionState> {
  final AiTextGenerationRepository _repository;

  Timer? _timeoutTimer;

  String? _currentRequestId;


  static const int _maxRetryAttempts = 3;

  int _retryCount = 0;

  AiGiftSuggestionCubit(this._repository) : super(const AiGiftSuggestionInitial()) {
    developer.log('AiGiftSuggestionCubit initialized', name: 'AiGiftSuggestionCubit');
  }

  Future<void> generateSuggestions({
    required Map<String, dynamic> profile,
    required Map<String, dynamic> filters,
  }) async {
    try {
      _retryCount = 0;
      _currentRequestId = DateTime.now().millisecondsSinceEpoch.toString();
      
      developer.log('Starting suggestion generation', name: 'AiGiftSuggestionCubit');

      final validationError = _validateInputData(profile, filters);
      if (validationError != null) {
        emit(AiGiftSuggestionError(
          message: validationError,
          errorCode: 'VALIDATION_ERROR',
          profile: profile,
          filters: filters,
          isRetryable: false,
        ));
        return;
      }

      emit(AiGiftSuggestionLoading(
        message: 'Analysing your preferences...',
        progress: 0.1,
        profile: profile,
        filters: filters,
      ));

      _startTimeoutTimer();

      emit(AiGiftSuggestionLoading(
        message: 'Generating personalised suggestions...',
        progress: 0.5,
        profile: profile,
        filters: filters,
      ));

      final suggestions = await _repository.generateGiftSuggestions(
        profile: profile,
        filters: filters,
      );

      _cancelTimeoutTimer();

      emit(AiGiftSuggestionLoading(
        message: 'Finalising suggestions...',
        progress: 0.9,
        profile: profile,
        filters: filters,
      ));

      if (suggestions.isEmpty) {
        emit(AiGiftSuggestionError(
          message: 'No gift suggestions were generated. Please try with different criteria.',
          errorCode: 'NO_SUGGESTIONS',
          profile: profile,
          filters: filters,
        ));
        return;
      }

      final qualityIssue = _validateSuggestionQuality(suggestions);
      if (qualityIssue != null) {
        developer.log('Suggestion quality issue: $qualityIssue', name: 'AiGiftSuggestionCubit');
        emit(AiGiftSuggestionError(
          message: 'Generated suggestions need improvement. Please try again.',
          errorCode: 'QUALITY_ERROR',
          technicalDetails: qualityIssue,
          profile: profile,
          filters: filters,
        ));
        return;
      }

      developer.log('Successfully generated ${suggestions.length} suggestions', name: 'AiGiftSuggestionCubit');
      
      emit(AiGiftSuggestionLoaded(
        suggestions: suggestions,
        profile: profile,
        filters: filters,
      ));
    } catch (e, stackTrace) {
      _cancelTimeoutTimer();
      developer.log('Error generating suggestions: $e', name: 'AiGiftSuggestionCubit', error: e, stackTrace: stackTrace);
      
      final errorInfo = _categorizeError(e);
      
      emit(AiGiftSuggestionError(
        message: errorInfo['message'],
        errorCode: errorInfo['code'],
        technicalDetails: e.toString(),
        profile: profile,
        filters: filters,
        isRetryable: errorInfo['retryable'],
      ));
    }
  }

  Future<void> retryGeneration() async {
    final currentState = state;
    if (currentState is! AiGiftSuggestionError) {
      developer.log('Cannot retry - current state is not error', name: 'AiGiftSuggestionCubit');
      return;
    }

    if (!currentState.isRetryable) {
      emit(AiGiftSuggestionError(
        message: 'This error cannot be retried. Please modify your input and try again.',
        errorCode: 'NOT_RETRYABLE',
        profile: currentState.profile,
        filters: currentState.filters,
        isRetryable: false,
      ));
      return;
    }

    if (_retryCount >= _maxRetryAttempts) {
      emit(AiGiftSuggestionError(
        message: 'Maximum retry attempts reached. Please try again later.',
        errorCode: 'MAX_RETRIES_EXCEEDED',
        profile: currentState.profile,
        filters: currentState.filters,
        isRetryable: false,
      ));
      return;
    }

    _retryCount++;
    developer.log('Retrying generation (attempt $_retryCount/$_maxRetryAttempts)', name: 'AiGiftSuggestionCubit');

    if (_retryCount > 1) {
      final delaySeconds = _retryCount * 2;
      emit(AiGiftSuggestionLoading(
        message: 'Retrying in $delaySeconds seconds...',
        progress: 0.0,
        profile: currentState.profile,
        filters: currentState.filters,
      ));
      
      await Future.delayed(Duration(seconds: delaySeconds));
    }

    await generateSuggestions(
      profile: currentState.profile ?? {},
      filters: currentState.filters ?? {},
    );
  }

  void cancelGeneration() {
    _cancelTimeoutTimer();
    _currentRequestId = null;
    
    if (state is AiGiftSuggestionLoading) {
      emit(const AiGiftSuggestionInitial());
      developer.log('Generation cancelled by user', name: 'AiGiftSuggestionCubit');
    }
  }

  /// Clear suggestions and reset to initial state
  void clearSuggestions() {
    _cancelTimeoutTimer();
    _currentRequestId = null;
    _retryCount = 0;
    emit(const AiGiftSuggestionInitial());
    developer.log('Suggestions cleared', name: 'AiGiftSuggestionCubit');
  }
  Future<void> regenerateSuggestions() async {
    final currentState = state;
    if (currentState is AiGiftSuggestionLoaded) {
      await generateSuggestions(
        profile: currentState.profile,
        filters: currentState.filters,
      );
    }
  }
  String? _validateInputData(Map<String, dynamic> profile, Map<String, dynamic> filters) {
    if (profile.isEmpty && filters.isEmpty) {
      return 'Please provide profile or filter information to generate suggestions';
    }

    final hasProfileContent = profile.values.any((value) => 
      value != null && value.toString().trim().isNotEmpty);
    final hasFilterContent = filters.values.any((value) => 
      value != null && value.toString().trim().isNotEmpty);

    if (!hasProfileContent && !hasFilterContent) {
      return 'Please provide more detailed information to generate better suggestions';
    }

    return null;
  }

  String? _validateSuggestionQuality(List<AiGiftSuggestion> suggestions) {
    if (suggestions.length < 3) {
      return 'Expected 3 suggestions, got ${suggestions.length}';
    }

    for (int i = 0; i < suggestions.length; i++) {
      final suggestion = suggestions[i];
      
      if (suggestion.title.isEmpty) {
        return 'Suggestion ${i + 1} has empty title';
      }
      
      if (suggestion.description.length < 20) {
        return 'Suggestion ${i + 1} has insufficient description';
      }
      
      if (suggestion.reason.length < 10) {
        return 'Suggestion ${i + 1} has insufficient reasoning';
      }
    }

    return null;
  }

  Map<String, dynamic> _categorizeError(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    if (errorString.contains('api key') || errorString.contains('unauthorized')) {
      return {
        'message': 'Configuration error. Please contact support.',
        'code': 'API_KEY_ERROR',
        'retryable': false,
      };
    }
    
    if (errorString.contains('network') || errorString.contains('connection')) {
      return {
        'message': 'Connection failed. Please check your internet and try again.',
        'code': 'NETWORK_ERROR',
        'retryable': true,
      };
    }
    
    if (errorString.contains('timeout')) {
      return {
        'message': 'Request timed out. Please try again.',
        'code': 'TIMEOUT_ERROR',
        'retryable': true,
      };
    }
    
    if (errorString.contains('parse') || errorString.contains('json')) {
      return {
        'message': 'Invalid response received. Please try again.',
        'code': 'PARSE_ERROR',
        'retryable': true,
      };
    }
    
    if (errorString.contains('rate limit') || errorString.contains('too many')) {
      return {
        'message': 'Too many requests. Please wait a moment and try again.',
        'code': 'RATE_LIMIT_ERROR',
        'retryable': true,
      };
    }
    
    return {
      'message': 'An unexpected error occurred. Please try again.',
      'code': 'UNKNOWN_ERROR',
      'retryable': true,
    };
  }

  void _startTimeoutTimer() {
    _cancelTimeoutTimer();
    _timeoutTimer = Timer(const Duration(seconds: 60), () {
      if (state is AiGiftSuggestionLoading) {
        emit(AiGiftSuggestionError(
          message: 'Request timed out. Please try again.',
          errorCode: 'TIMEOUT_ERROR',
          profile: (state as AiGiftSuggestionLoading).profile,
          filters: (state as AiGiftSuggestionLoading).filters,
        ));
      }
    });
  }

  void _cancelTimeoutTimer() {
    _timeoutTimer?.cancel();
    _timeoutTimer = null;
  }

  List<AiGiftSuggestion>? get currentSuggestions {
    final currentState = state;
    if (currentState is AiGiftSuggestionLoaded) {
      return currentState.suggestions;
    }
    return null;
  }

  bool get isLoading => state is AiGiftSuggestionLoading;

  bool get hasError => state is AiGiftSuggestionError;

  bool get hasResults => state is AiGiftSuggestionLoaded;

  bool get isInitial => state is AiGiftSuggestionInitial;

  String? get errorMessage {
    final currentState = state;
    if (currentState is AiGiftSuggestionError) {
      return currentState.userFriendlyMessage;
    }
    return null;
  }

  double? get loadingProgress {
    final currentState = state;
    if (currentState is AiGiftSuggestionLoading) {
      return currentState.progress;
    }
    return null;
  }

  String? get loadingMessage {
    final currentState = state;
    if (currentState is AiGiftSuggestionLoading) {
      return currentState.message;
    }
    return null;
  }

  int get retryCount => _retryCount;

  bool get canRetry {
    final currentState = state;
    return currentState is AiGiftSuggestionError && 
           currentState.isRetryable && 
           _retryCount < _maxRetryAttempts;
  }

  @override
  Future<void> close() {
    _cancelTimeoutTimer();
    developer.log('AiGiftSuggestionCubit disposed', name: 'AiGiftSuggestionCubit');
    return super.close();
  }
}