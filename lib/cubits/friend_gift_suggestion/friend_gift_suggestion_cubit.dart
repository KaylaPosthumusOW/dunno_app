import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dunno/repositories/ai_text_generation_repository.dart';
import 'friend_gift_suggestion_state.dart';

class FriendGiftSuggestionCubit extends Cubit<FriendGiftSuggestionState> {
  final AiTextGenerationRepository _repository;

  Timer? _timeoutTimer;

  static const int _maxRetryAttempts = 3;

  int _retryCount = 0;

  FriendGiftSuggestionCubit(this._repository) : super(const FriendGiftSuggestionInitial()) {
    developer.log('FriendGiftSuggestionCubit initialized', name: 'FriendGiftSuggestionCubit');
  }

  Future<void> generateSuggestions({
    required Map<String, dynamic> profile,
    required Map<String, dynamic> filters,
  }) async {
    try {
      _retryCount = 0;
      
      developer.log('Starting friend gift suggestion generation', name: 'FriendGiftSuggestionCubit');

      final validationError = _validateInputData(profile, filters);
      if (validationError != null) {
        emit(FriendGiftSuggestionError(
          message: validationError,
          errorCode: 'VALIDATION_ERROR',
          profile: profile,
          filters: filters,
          isRetryable: false,
        ));
        return;
      }

      emit(FriendGiftSuggestionLoading(
        message: 'Analysing friend\'s preferences...',
        progress: 0.1,
        profile: profile,
        filters: filters,
      ));

      _startTimeout();

      await _performGeneration(profile, filters);
    } catch (e, stackTrace) {
      developer.log(
        'Unexpected error in generateSuggestions',
        name: 'FriendGiftSuggestionCubit',
        error: e,
        stackTrace: stackTrace,
      );
      emit(FriendGiftSuggestionError(
        message: 'An unexpected error occurred. Please try again.',
        errorCode: 'UNEXPECTED_ERROR',
        profile: profile,
        filters: filters,
      ));
    }
  }

  Future<void> _performGeneration(Map<String, dynamic> profile, Map<String, dynamic> filters) async {
    try {
      emit(FriendGiftSuggestionLoading(
        message: 'Creating personalised gift ideas...',
        progress: 0.5,
        profile: profile,
        filters: filters,
      ));

      final suggestions = await _repository.generateGiftSuggestions(
        profile: profile,
        filters: filters,
      );

      _cancelTimeout();

      if (suggestions.isEmpty) {
        emit(FriendGiftSuggestionError(
          message: 'No suggestions could be generated. Please try adjusting your preferences.',
          errorCode: 'NO_SUGGESTIONS',
          profile: profile,
          filters: filters,
          isRetryable: true,
        ));
        return;
      }

      developer.log('Successfully generated ${suggestions.length} friend gift suggestions', name: 'FriendGiftSuggestionCubit');

      emit(FriendGiftSuggestionLoaded(
        suggestions: suggestions,
        profile: profile,
        filters: filters,
      ));
    } catch (e, stackTrace) {
      _cancelTimeout();
      developer.log(
        'Error in _performGeneration',
        name: 'FriendGiftSuggestionCubit',
        error: e,
        stackTrace: stackTrace,
      );

      if (_retryCount < _maxRetryAttempts) {
        _retryCount++;
        developer.log('Retrying generation (attempt $_retryCount/$_maxRetryAttempts)', name: 'FriendGiftSuggestionCubit');
        await Future.delayed(Duration(seconds: _retryCount));
        await _performGeneration(profile, filters);
      } else {
        emit(FriendGiftSuggestionError(
          message: 'Unable to generate suggestions after multiple attempts. Please try again later.',
          errorCode: 'GENERATION_FAILED',
          profile: profile,
          filters: filters,
          isRetryable: true,
        ));
      }
    }
  }

  Future<void> retryGeneration() async {
    final currentState = state;
    if (currentState is FriendGiftSuggestionError) {
      await generateSuggestions(
        profile: currentState.profile,
        filters: currentState.filters,
      );
    }
  }

  void reset() {
    _cancelTimeout();
    _retryCount = 0;
    emit(const FriendGiftSuggestionInitial());
    developer.log('FriendGiftSuggestionCubit reset', name: 'FriendGiftSuggestionCubit');
  }

  String? _validateInputData(Map<String, dynamic> profile, Map<String, dynamic> filters) {
    if (profile.isEmpty && filters.isEmpty) {
      return 'Please provide some information about your friend to generate suggestions.';
    }
    return null;
  }

  void _startTimeout() {
    _cancelTimeout();
    _timeoutTimer = Timer(const Duration(seconds: 45), () {
      if (!isClosed) {
        emit(const FriendGiftSuggestionError(
          message: 'Request timed out. Please try again.',
          errorCode: 'TIMEOUT',
          profile: {},
          filters: {},
          isRetryable: true,
        ));
      }
    });
  }

  void _cancelTimeout() {
    _timeoutTimer?.cancel();
    _timeoutTimer = null;
  }

  @override
  Future<void> close() {
    _cancelTimeout();
    return super.close();
  }
}