import 'package:dunno/cubits/ai_gift_suggestion/ai_gift_suggestion_cubit.dart';
import 'package:dunno/cubits/ai_gift_suggestion/ai_gift_suggestion_state.dart';
import 'package:dunno/models/ai_gift_suggestion.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

part 'quick_generate_suggestion_flow_state.dart';

class QuickGiftGenerationCubit extends Cubit<QuickGenerateSuggestionFlowState> {
  final AiGiftSuggestionCubit _aiCubit = GetIt.instance<AiGiftSuggestionCubit>();

  QuickGiftGenerationCubit() : super(const QuickGenerationSuggestionInitial());

  void saveProfile(Map<String, dynamic> profile) {
    final newState = state.mainQuickGenerationState.copyWith(profileData: profile, message: 'Profile saved');
    emit(SavingProfile(newState));
    emit(ProfileSaved(newState));
  }

  void saveFilter(Map<String, dynamic> filter) {
    final newState = state.mainQuickGenerationState.copyWith(filterData: filter, message: 'Filter saved');
    emit(SavingFilter(newState));
    emit(FilterSaved(newState));
  }

  Future<void> generateSuggestions() async {
    if (state.mainQuickGenerationState.profileData == null || state.mainQuickGenerationState.filterData == null) {
      emit(QuickGiftGenerationError(
        state.mainQuickGenerationState.copyWith(message: 'Missing profile or filter data'),
        stackTrace: '',
      ));
      return;
    }

    emit(QuickGiftGenerationLoading(state.mainQuickGenerationState.copyWith(message: 'Generating suggestions...')));

    try {
      // Use the AI cubit to generate suggestions
      await _aiCubit.generateSuggestions(
        profile: state.mainQuickGenerationState.profileData!,
        filters: state.mainQuickGenerationState.filterData!,
      );

      // Check the result from the AI cubit
      final aiState = _aiCubit.state;
      if (aiState is AiGiftSuggestionLoaded) {
        emit(QuickGiftGenerationLoaded(
          state.mainQuickGenerationState.copyWith(
            giftSuggestions: aiState.suggestions,
            message: 'Suggestions generated: ${aiState.suggestions.length}',
          ),
        ));
      } else if (aiState is AiGiftSuggestionError) {
        emit(QuickGiftGenerationError(
          state.mainQuickGenerationState.copyWith(message: '', errorMessage: aiState.message),
          stackTrace: aiState.errorCode ?? '',
        ));
      }
    } catch (error, stackTrace) {
      emit(QuickGiftGenerationError(
        state.mainQuickGenerationState.copyWith(message: '', errorMessage: error.toString()),
        stackTrace: stackTrace.toString(),
      ));
    }
  }
}
