import 'package:dunno/constants/constants.dart';
import 'package:dunno/constants/themes.dart';
import 'package:dunno/cubits/friend_gift_suggestion/friend_gift_suggestion_cubit.dart';
import 'package:dunno/ui/widgets/custom_header_bar.dart';
import 'package:dunno/ui/widgets/dunno_button.dart';
import 'package:dunno/ui/widgets/dunno_text_field.dart';
import 'package:dunno/ui/widgets/gift_loading_indicator.dart';
import 'package:dunno/ui/widgets/gift_suggestion_card.dart';
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
  final TextEditingController _refinementController = TextEditingController();

  @override
  void dispose() {
    _refinementController.dispose();
    super.dispose();
  }

  Map<String, dynamic> _buildProfileFromFriendData() {
    if (widget.friendData == null || widget.collectionData == null) {
      return {};
    }

    final friend = widget.friendData!;
    final collection = widget.collectionData!;

    final likes = collection['likes'] as Map<String, dynamic>?;

    return {
      'eventType': 'Gift for Friend',
      'gender': _inferGenderFromName(friend['name']),
      'likes': likes,
      'extraNotes': 'Gift for ${friend['name']} ${friend['surname'] ?? ''}',
    };
  }

  String _inferGenderFromName(String? name) {
    if (name == null) return 'Not specified';

    final femaleNames = ['sarah', 'emma', 'olivia', 'ava', 'isabella', 'sophia', 'mia', 'charlotte', 'amelia', 'harper'];
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
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: Column(
        children: [
          CustomHeaderBar(
            title: 'Gift Ideas for ${widget.friendData?['name'] ?? 'Friend'}',
            backgroundColor: AppColors.offWhite,
            onBack: () => Navigator.of(context).pop(),
            backButtonColor: AppColors.cerise,
            iconColor: AppColors.offWhite,
          ),
          Expanded(
            child: BlocProvider(
              create: (_) => sl<FriendGiftSuggestionCubit>(),
              child: SingleChildScrollView(
                child: BlocBuilder<FriendGiftSuggestionCubit, FriendGiftSuggestionState>(
                  builder: (context, state) {
            if (state is FriendGiftSuggestionInitial) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<FriendGiftSuggestionCubit>().reset();
                final profile = _buildProfileFromFriendData();
                final filters = widget.filterData ?? {};
                
                context.read<FriendGiftSuggestionCubit>().generateSuggestions(
                  profile: profile,
                  filters: filters,
                );
              });
              
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
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
                ),
              );
            }

            if (state is FriendGiftSuggestionLoading) {
              return Center(
                child: GiftLoadingIndicator(
                  lottieAsset: 'assets/animations/birthday_gifts_pink.json',
                  messages: [
                    'Thinking of the perfect gift...',
                    'Browsing the best options...',
                    'Almost there, just a moment...',
                  ],
                  interval: Duration(seconds: 3),
                ),
              );
            }

            if (state is FriendGiftSuggestionError) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
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
                          state.main.errorMessage ?? 'Unknown error occurred',
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        DunnoButton(
                          type: ButtonType.primary,
                          label: 'Try Again',
                          onPressed: () {
                            context.read<FriendGiftSuggestionCubit>().retryGeneration();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            if (state is FriendGiftSuggestionLoaded) {
              return Column(
                children: [
                  SizedBox(height: 12,),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: state.main.suggestions?.length ?? 0,
                    itemBuilder: (context, index) {
                      final suggestion = state.main.suggestions![index];
                      return GiftSuggestionCard(
                        suggestion: suggestion,
                        index: index,
                        isPink: true,
                        isSaved: false,
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        DunnoTextField(
                          controller: _refinementController,
                          label: 'Refine suggestions',
                          supportingText: 'e.g., "I like the first suggestion, but prefer something more practical"',
                          keyboardType: TextInputType.text,
                          isLight: true,
                          colorScheme: DunnoTextFieldColor.pink, // Use pink theme for friend flow
                          maxLines: 3,
                          onChanged: (value) {
                            // Handle input changes if needed
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: DunnoButton(
                                type: ButtonType.outlineCerise,
                                label: 'Edit Filters',
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DunnoButton(
                                type: ButtonType.primary,
                                label: 'Regenerate',
                                onPressed: () {
                                  final refinement = _refinementController.text.trim();

                                  final updatedFilters = Map<String, dynamic>.from(widget.filterData ?? {});
                                  if (refinement.isNotEmpty) {
                                    updatedFilters['refinement'] = refinement;
                                  }

                                  final profile = _buildProfileFromFriendData();
                                  context.read<FriendGiftSuggestionCubit>().generateSuggestions(
                                    profile: profile,
                                    filters: updatedFilters,
                                  );

                                  _refinementController.clear();
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
        ],
      ),
    );
  }
}
