import 'dart:async';
import 'package:dunno/constants/constants.dart';
import 'package:dunno/constants/themes.dart';
import 'package:dunno/cubits/friend_gift_suggestion/friend_gift_suggestion_cubit.dart';
import 'package:dunno/ui/widgets/custom_header_bar.dart';
import 'package:dunno/ui/widgets/dunno_button.dart';
import 'package:dunno/ui/widgets/dunno_text_field.dart';
import 'package:dunno/ui/widgets/gift_suggestion_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

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

  // UI state
  Timer? _messageTimer;
  int _msgIndex = 0;
  bool _isGenerating = false;
  bool _showIntroAnimation = false;
  bool _showCards = false;

  final List<String> _defaultMessages = [
    'Thinking of the perfect gift...',
    'Browsing the best options...',
    'Almost there, just a moment...',
  ];

  void _startMessageCycler([List<String>? messages, Duration? interval]) {
    _messageTimer?.cancel();
    final msgs = messages ?? _defaultMessages;
    final dur = interval ?? const Duration(seconds: 2);
    _msgIndex = 0;
    _messageTimer = Timer.periodic(dur, (_) {
      if (!mounted) return;
      setState(() => _msgIndex = (_msgIndex + 1) % msgs.length);
    });
  }

  void _stopMessageCycler() {
    _messageTimer?.cancel();
    _messageTimer = null;
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
  void dispose() {
    _refinementController.dispose();
    _stopMessageCycler();
    super.dispose();
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
                child: BlocConsumer<FriendGiftSuggestionCubit, FriendGiftSuggestionState>(
                  listener: (context, state) {
                    if (state is FriendGiftSuggestionLoading) {
                      if (!mounted) return;
                      setState(() {
                        _isGenerating = true;
                        _showIntroAnimation = false;
                        _showCards = false;
                      });
                      _startMessageCycler();
                    }

                    if (state is FriendGiftSuggestionLoaded) {
                      _stopMessageCycler();
                      if (!mounted) return;
                      setState(() {
                        _isGenerating = false;
                        _showIntroAnimation = true;
                        _showCards = false;
                        _msgIndex = 0;
                      });

                      Future.delayed(const Duration(seconds: 2), () {
                        if (!mounted) return;
                        setState(() {
                          _showIntroAnimation = false;
                          _showCards = true;
                        });
                      });
                    }

                    if (state is FriendGiftSuggestionError) {
                      _stopMessageCycler();
                      if (!mounted) return;
                      setState(() {
                        _isGenerating = false;
                        _showIntroAnimation = false;
                        _showCards = false;
                      });
                    }
                  },
                  buildWhen: (previous, current) => true,
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
                              Icon(Icons.card_giftcard, size: 64, color: AppColors.tangerine),
                              const SizedBox(height: 20),
                              Text(
                                'Ready to generate gift suggestions',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.black),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Based on ${widget.friendData?['name']}'s collection",
                                style: const TextStyle(fontSize: 16, color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (_isGenerating || state is FriendGiftSuggestionLoading) {
                      final currentMessage = _defaultMessages[_msgIndex % _defaultMessages.length];

                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  minHeight: 8,
                                  backgroundColor: AppColors.offWhite,
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.cerise),
                                ),
                              ),
                              const SizedBox(height: 20),

                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 400),
                                child: Text(
                                  currentMessage,
                                  key: ValueKey(currentMessage),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.cerise),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (_showIntroAnimation) {
                      return Column(
                        children: [
                          const SizedBox(height: 24),
                          Center(
                            child: Lottie.asset(
                              'assets/animations/birthday_gifts_pink.json',
                              repeat: false,
                              width: 300,
                              height: 300,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      );
                    }

                    if (_showCards && state is FriendGiftSuggestionLoaded) {
                      final suggestions = state.main.suggestions ?? [];
                      return Column(
                        children: [
                          const SizedBox(height: 12),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: suggestions.length,
                            itemBuilder: (context, index) {
                              final suggestion = suggestions[index];
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
                                  colorScheme: DunnoTextFieldColor.pink,
                                  maxLines: 3,
                                  onChanged: (value) {},
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
                                          if (refinement.isNotEmpty) updatedFilters['refinement'] = refinement;
                                          final profile = _buildProfileFromFriendData();
                                          context.read<FriendGiftSuggestionCubit>().generateSuggestions(profile: profile, filters: updatedFilters);
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

                    if (state is FriendGiftSuggestionError) {
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error_outline, size: 64, color: AppColors.errorRed),
                                const SizedBox(height: 20),
                                Text('Oops! Something went wrong', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600, color: AppColors.black), textAlign: TextAlign.center),
                                const SizedBox(height: 12),
                                Text(state.main.errorMessage ?? 'Unknown error occurred', style: const TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.center),
                                const SizedBox(height: 30),
                                DunnoButton(type: ButtonType.primary, label: 'Try Again', onPressed: () => context.read<FriendGiftSuggestionCubit>().retryGeneration()),
                              ],
                            ),
                          ),
                        ),
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
