part of 'quick_generate_suggestion_flow_cubit.dart';

class MainQuickGenerationState extends Equatable {
  final Map<String, dynamic>? profileData;
  final Map<String, dynamic>? filterData;
  final List<AiGiftSuggestion>? giftSuggestions;
  final String message;
  final String? errorMessage;

  const MainQuickGenerationState({
    this.profileData,
    this.filterData,
    this.giftSuggestions,
    this.message = '',
    this.errorMessage,
  });

  MainQuickGenerationState copyWith({
    Map<String, dynamic>? profileData,
    Map<String, dynamic>? filterData,
    List<AiGiftSuggestion>? giftSuggestions,
    String? message,
    String? errorMessage,
  }) {
    return MainQuickGenerationState(
      profileData: profileData ?? this.profileData,
      filterData: filterData ?? this.filterData,
      giftSuggestions: giftSuggestions,
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [profileData, filterData, giftSuggestions, message, errorMessage];
}

abstract class QuickGenerateSuggestionFlowState extends Equatable {
  final MainQuickGenerationState mainQuickGenerationState;
  const QuickGenerateSuggestionFlowState(this.mainQuickGenerationState);

  @override
  List<Object?> get props => [mainQuickGenerationState];
}

class QuickGenerationSuggestionInitial extends QuickGenerateSuggestionFlowState {
  const QuickGenerationSuggestionInitial() : super(const MainQuickGenerationState());
}

class SavingProfile extends QuickGenerateSuggestionFlowState {
  const SavingProfile(MainQuickGenerationState mainQuickGenerationState) : super(mainQuickGenerationState);
}

class ProfileSaved extends QuickGenerateSuggestionFlowState {
  const ProfileSaved(MainQuickGenerationState mainQuickGenerationState) : super(mainQuickGenerationState);
}

class SavingFilter extends QuickGenerateSuggestionFlowState {
  const SavingFilter(MainQuickGenerationState mainQuickGenerationState) : super(mainQuickGenerationState);
}

class FilterSaved extends QuickGenerateSuggestionFlowState {
  const FilterSaved(MainQuickGenerationState mainQuickGenerationState) : super(mainQuickGenerationState);
}

class QuickGiftGenerationLoading extends QuickGenerateSuggestionFlowState {
  const QuickGiftGenerationLoading(MainQuickGenerationState mainQuickGenerationState) : super(mainQuickGenerationState);
}

class QuickGiftGenerationLoaded extends QuickGenerateSuggestionFlowState {
  const QuickGiftGenerationLoaded(MainQuickGenerationState mainQuickGenerationState) : super(mainQuickGenerationState);
}

class QuickGiftGenerationError extends QuickGenerateSuggestionFlowState {
  final String stackTrace;
  const QuickGiftGenerationError(MainQuickGenerationState mainQuickGenerationState, {required this.stackTrace}) : super(mainQuickGenerationState);

  @override
  List<Object?> get props => [mainQuickGenerationState, stackTrace];
}
