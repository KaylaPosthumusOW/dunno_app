import 'package:dunno/constants/constants.dart';
import 'package:dunno/constants/themes.dart';
import 'package:dunno/cubits/ai_gift_suggestion/ai_gift_suggestion_cubit.dart';
import 'package:dunno/cubits/ai_gift_suggestion/ai_gift_suggestion_state.dart';
import 'package:dunno/ui/widgets/dunno_button.dart';
import 'package:dunno/ui/widgets/gift_suggestion_card.dart';
import 'package:dunno/ui/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FriendGiftSuggestionsScreen extends StatefulWidget {
  final Map<String, dynamic>? friendData;
  final Map<String, dynamic>? collectionData;
  final Map<String, dynamic>? filterData;

  const FriendGiftSuggestionsScreen({
    super.key,
    this.friendData,
    this.collectionData,
    this.filterData,
  });

  @override
  State<FriendGiftSuggestionsScreen> createState() => _FriendGiftSuggestionsScreenState();
}

class _FriendGiftSuggestionsScreenState extends State<FriendGiftSuggestionsScreen> {
  
  Map<String, dynamic> _buildProfileFromFriendData() {
    if (widget.friendData == null || widget.collectionData == null) {
      return {};
    }

    final friend = widget.friendData!;
    final collection = widget.collectionData!;
    
    // Extract collection likes data
    final likes = collection['likes'] as Map<String, dynamic>?;
    
    return {
      'eventType': 'Gift for Friend',
      'gender': _inferGenderFromName(friend['name']),
      'likes': likes,
      'extraNotes': 'Gift for ${friend['name']} ${friend['surname'] ?? ''}',
    };
  }

  String _inferGenderFromName(String? name) {
    // Simple gender inference - in a real app, you might want to store this in the profile
    // or use a more sophisticated method
    if (name == null) return 'Not specified';
    
    final femaleNames = ['sarah', 'emma', 'olivia', 'ava', 'isabella', 'sophia', 'mia', 'charlotte'];
    final maleNames = ['james', 'robert', 'john', 'michael', 'david', 'william', 'richard', 'joseph'];
    
    final lowerName = name.toLowerCase();
    
    if (femaleNames.any((n) => lowerName.contains(n))) {
      return 'Woman';
    } else if (maleNames.any((n) => lowerName.contains(n))) {
      return 'Man';
    }
    
    return 'Not specified';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AiGiftSuggestionCubit>(),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocBuilder<AiGiftSuggestionCubit, AiGiftSuggestionState>(
          builder: (context, state) {
            if (state is AiGiftSuggestionInitial) {
              // Auto-generate suggestions when screen loads
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final profile = _buildProfileFromFriendData();
                final filters = widget.filterData ?? {};
                
                context.read<AiGiftSuggestionCubit>().generateSuggestions(
                  profile: profile,
                  filters: filters,
                );
              });
              
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.card_giftcard,
                      size: 64,
                      color: AppColors.tangerine,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Ready to generate gift suggestions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Based on ${widget.friendData?['name']}'s collection",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            if (state is AiGiftSuggestionLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const LoadingIndicator(color: null),
                    const SizedBox(height: 20),
                    Text(
                      state.message,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Analyzing ${widget.friendData?['name']}'s preferences...",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            if (state is AiGiftSuggestionError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppColors.errorRed,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Oops! Something went wrong',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        state.message,
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      DunnoButton(
                        type: ButtonType.primary,
                        label: 'Try Again',
                        onPressed: () {
                          context.read<AiGiftSuggestionCubit>().retryGeneration();
                        },
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is AiGiftSuggestionLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Gift Ideas for ${widget.friendData?['name']}",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Based on their collection preferences',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.suggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion = state.suggestions[index];
                        return GiftSuggestionCard(
                          suggestion: suggestion,
                          index: index,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  DunnoButton(
                    type: ButtonType.secondary,
                    label: 'Generate New Suggestions',
                    onPressed: () {
                      final profile = _buildProfileFromFriendData();
                      final filters = widget.filterData ?? {};
                      
                      context.read<AiGiftSuggestionCubit>().generateSuggestions(
                        profile: profile,
                        filters: filters,
                      );
                    },
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
