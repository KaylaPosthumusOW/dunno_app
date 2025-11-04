import 'dart:async';
import 'package:dunno/constants/constants.dart';
import 'package:dunno/constants/themes.dart';
import 'package:dunno/cubits/ai_gift_suggestion/ai_gift_suggestion_cubit.dart';
import 'package:dunno/cubits/ai_gift_suggestion/ai_gift_suggestion_state.dart';
import 'package:dunno/ui/widgets/custom_header_bar.dart';
import 'package:dunno/ui/widgets/dunno_button.dart';
import 'package:dunno/ui/widgets/dunno_text_field.dart';
import 'package:dunno/ui/widgets/gift_suggestion_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class ReceiveGiftSuggestionScreen extends StatefulWidget {
  final Map<String, dynamic>? profile;
  final Map<String, dynamic>? filters;
  final VoidCallback? onBackToEdit;

  const ReceiveGiftSuggestionScreen({super.key, this.profile, this.filters, this.onBackToEdit});

  @override
  State<ReceiveGiftSuggestionScreen> createState() => _ReceiveGiftSuggestionScreenState();
}

class _ReceiveGiftSuggestionScreenState extends State<ReceiveGiftSuggestionScreen> {
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
            title: 'Your Gift Suggestions',
            backgroundColor: Colors.transparent,
            onBack: () => Navigator.of(context).maybePop(),
            backButtonColor: AppColors.cinnabar,
            iconColor: AppColors.offWhite,
          ),
          Expanded(
            child: BlocProvider(
              create: (_) => sl<AiGiftSuggestionCubit>()..clearSuggestions(),
              child: SingleChildScrollView(
                child: BlocConsumer<AiGiftSuggestionCubit, AiGiftSuggestionState>(
                  listener: (context, state) {
                    // handle state transitions
                    if (state is AiGiftSuggestionLoading) {
                      // start generating UI and message cycling
                      if (!mounted) return;
                      setState(() {
                        _isGenerating = true;
                        _showIntroAnimation = false;
                        _showCards = false;
                      });
                      _startMessageCycler(); // Start the message cycling
                    }

                    if (state is AiGiftSuggestionLoaded) {
                      // stop messages, show animation once then show cards
                      _stopMessageCycler();
                      if (!mounted) return;
                      setState(() {
                        _isGenerating = false;
                        _showIntroAnimation = true; // show Lottie once
                        _showCards = false;
                        _msgIndex = 0;
                      });

                      // Show animation for 2 seconds then show cards
                      Future.delayed(const Duration(seconds: 2), () {
                        if (!mounted) return;
                        setState(() {
                          _showIntroAnimation = false;
                          _showCards = true;
                        });
                      });
                    }

                    if (state is AiGiftSuggestionError) {
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
              if (state is AiGiftSuggestionInitial) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  context.read<AiGiftSuggestionCubit>().generateSuggestions(profile: widget.profile ?? {}, filters: widget.filters ?? {});
                });

                return const Center(
                  child: Text(
                    'Ready to generate gift suggestions',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              // Loading: show linear indicator + cycling message
              if (_isGenerating || state is AiGiftSuggestionLoading) {
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
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.tangerine),
                          ),
                        ),
                        const SizedBox(height: 20),

                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child: Text(
                            currentMessage,
                            key: ValueKey(currentMessage),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.tangerine),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // After the cubit reports loaded we show the intro animation once,
              // then show cards (the listener toggles _showIntroAnimation / _showCards).
              if (_showIntroAnimation) {
                return Column(
                  children: [
                    const SizedBox(height: 24),
                    Center(
                      child: Lottie.asset(
                        'assets/animations/birthday_gifts_orange.json',
                        repeat: false,
                        width: 300,
                        height: 300,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                );
              }

              if (_showCards && state is AiGiftSuggestionLoaded) {
                return Column(
                  children: [
                    SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: state.suggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion = state.suggestions[index];
                        return GiftSuggestionCard(suggestion: suggestion, index: index, isPink: false, isSaved: false);
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
                            colorScheme: DunnoTextFieldColor.antiqueWhite,
                            maxLines: 3,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: DunnoButton(type: ButtonType.outlineCinnabar, label: 'Edit Profile/Filter', onPressed:() => Navigator.of(context).pop()),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: DunnoButton(
                                  type: ButtonType.cinnabar,
                                  label: 'Regenerate',
                                  onPressed: () {
                                    final refinement = _refinementController.text.trim();

                                    final updatedFilters = Map<String, dynamic>.from(widget.filters ?? {});
                                    if (refinement.isNotEmpty) {
                                      updatedFilters['refinement'] = refinement;
                                    }

                                    context.read<AiGiftSuggestionCubit>().generateSuggestions(profile: widget.profile ?? {}, filters: updatedFilters);

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

              if (state is AiGiftSuggestionError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 64, color: AppColors.errorRed),
                        const SizedBox(height: 20),
                        Text(
                          'Oops! Something went wrong',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600, color: AppColors.black),
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
                        const SizedBox(height: 12),
                        DunnoButton(
                          type: ButtonType.secondary,
                          label: 'Go Back',
                          icon: Icon(Icons.arrow_back_rounded, color: AppColors.antiqueWhite),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
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
