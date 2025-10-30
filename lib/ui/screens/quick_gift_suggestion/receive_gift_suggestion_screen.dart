import 'package:dunno/constants/constants.dart';
import 'package:dunno/constants/themes.dart';
import 'package:dunno/cubits/ai_gift_suggestion/ai_gift_suggestion_cubit.dart';
import 'package:dunno/cubits/ai_gift_suggestion/ai_gift_suggestion_state.dart';
import 'package:dunno/ui/widgets/dunno_button.dart';
import 'package:dunno/ui/widgets/dunno_text_field.dart';
import 'package:dunno/ui/widgets/gift_suggestion_card.dart';
import 'package:dunno/ui/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  @override
  void dispose() {
    _refinementController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        centerTitle: false,
        leadingWidth: 50,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back_rounded, size: 20, color: Colors.white),
            style: IconButton.styleFrom(backgroundColor: AppColors.cinnabar, shape: const CircleBorder(), minimumSize: const Size(36, 36), padding: EdgeInsets.zero),
          ),
        ),
        titleSpacing: 20,
        title: Text(
          'Your Gift Suggestions',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: AppColors.black),
          overflow: TextOverflow.ellipsis,
        ),
      ),

      body: BlocProvider(
        create: (_) => sl<AiGiftSuggestionCubit>()..clearSuggestions(),
        child: SingleChildScrollView(
          child: BlocBuilder<AiGiftSuggestionCubit, AiGiftSuggestionState>(
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

              if (state is AiGiftSuggestionLoading) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const LoadingIndicator(color: null),
                      const SizedBox(height: 20),
                      Text(
                        state.message,
                        style: const TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
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

              if (state is AiGiftSuggestionLoaded) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                              'We found ${state.suggestions.length} perfect gifts for you',
                              style: const TextStyle(fontSize: 16, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: state.suggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion = state.suggestions[index];
                        return GiftSuggestionCard(suggestion: suggestion, index: index, isPink: false);
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
                            onChanged: (value) {
                              // Handle input changes if needed
                            },
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: DunnoButton(type: ButtonType.outlineCinnabar, label: 'Edit Profile/Filter', onPressed: widget.onBackToEdit),
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

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
