import 'dart:async';
import 'dart:developer' as developer;
import 'package:dunno/models/ai_gift_suggestion.dart';
import 'package:dunno/repositories/ai_text_generation_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'friend_gift_suggestion_state.dart';

class FriendGiftSuggestionCubit extends Cubit<FriendGiftSuggestionState> {
  final AiTextGenerationRepository _aiRepo;

  Timer? _timeoutTimer;
  static const int _maxRetryAttempts = 3;
  int _retryCount = 0;

  FriendGiftSuggestionCubit(this._aiRepo) : super(const FriendGiftSuggestionInitial()) {
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
        emit(
          FriendGiftSuggestionError(
            state.main.copyWith(
              message: '',
              errorMessage: validationError,
              profile: profile,
              filters: filters,
              isRetryable: false,
            ),
            errorCode: 'VALIDATION_ERROR',
          ),
        );
        return;
      }

      emit(
        FriendGiftSuggestionLoading(
          state.main.copyWith(
            message: 'Analysing friend\'s preferences...',
            progress: 0.1,
            profile: profile,
            filters: filters,
          ),
        ),
      );

      _startTimeout();
      await _performGeneration(profile, filters);
    } catch (e, stackTrace) {
      developer.log(
        'Unexpected error in generateSuggestions',
        name: 'FriendGiftSuggestionCubit',
        error: e,
        stackTrace: stackTrace,
      );
      emit(
        FriendGiftSuggestionError(
          state.main.copyWith(
            message: '',
            errorMessage: 'An unexpected error occurred. Please try again.',
            profile: profile,
            filters: filters,
            isRetryable: true,
          ),
          errorCode: 'UNEXPECTED_ERROR',
          stackTraceString: stackTrace.toString(),
        ),
      );
    }
  }

  Future<void> _performGeneration(
      Map<String, dynamic> profile,
      Map<String, dynamic> filters,
      ) async {
    try {
      emit(
        FriendGiftSuggestionLoading(
          state.main.copyWith(
            message: 'Creating personalised gift ideas...',
            progress: 0.5,
            profile: profile,
            filters: filters,
          ),
        ),
      );

      final List<AiGiftSuggestion> suggestions = await _aiRepo.generateGiftSuggestions(
        profile: profile,
        filters: filters,
      );

      _cancelTimeout();

      if (suggestions.isEmpty) {
        emit(
          FriendGiftSuggestionError(
            state.main.copyWith(
              message: '',
              errorMessage: 'No suggestions could be generated. Please try adjusting your preferences.',
              profile: profile,
              filters: filters,
              isRetryable: true,
            ),
            errorCode: 'NO_SUGGESTIONS',
          ),
        );
        return;
      }

      developer.log(
          'Successfully generated ${suggestions.length} friend gift suggestions',
          name: 'FriendGiftSuggestionCubit');

      emit(
        FriendGiftSuggestionLoaded(
          state.main.copyWith(
            suggestions: suggestions,
            profile: profile,
            filters: filters,
            message: '',
            errorMessage: null,
          ),
        ),
      );
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
        emit(
          FriendGiftSuggestionError(
            state.main.copyWith(
              message: '',
              errorMessage: 'Unable to generate suggestions after multiple attempts. Please try again later.',
              profile: profile,
              filters: filters,
              isRetryable: true,
            ),
            errorCode: 'GENERATION_FAILED',
            stackTraceString: stackTrace.toString(),
          ),
        );
      }
    }
  }

  Future<void> retryGeneration() async {
    if (state is FriendGiftSuggestionError) {
      await generateSuggestions(
        profile: state.main.profile ?? {},
        filters: state.main.filters ?? {},
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
        emit(
          FriendGiftSuggestionError(
            state.main.copyWith(
              message: '',
              errorMessage: 'Request timed out. Please try again.',
              isRetryable: true,
            ),
            errorCode: 'TIMEOUT',
          ),
        );
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
