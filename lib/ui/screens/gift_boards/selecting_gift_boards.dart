import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dunno/constants/constants.dart';
import 'package:dunno/constants/themes.dart';
import 'package:dunno/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:dunno/cubits/gift_board/gift_board_cubit.dart';
import 'package:dunno/models/ai_gift_suggestion.dart';
import 'package:dunno/models/board_gift_suggestion.dart';
import 'package:dunno/ui/widgets/dunno_button.dart';
import 'package:dunno/ui/widgets/dunno_extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectingGiftBoards extends StatefulWidget {
  final AiGiftSuggestion? giftSuggestions;

  const SelectingGiftBoards({super.key, this.giftSuggestions});

  @override
  State<SelectingGiftBoards> createState() => _SelectingGiftBoardsState();
}

class _SelectingGiftBoardsState extends State<SelectingGiftBoards> {
  final GiftBoardCubit _giftBoardCubit = sl<GiftBoardCubit>();
  final AppUserProfileCubit _appUserProfileCubit = sl<AppUserProfileCubit>();

  @override
  void initState() {
    super.initState();
    _giftBoardCubit.loadAllUserGiftBoards(ownerUid: _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile?.uid ?? '');
  }

  Future<void> _saveSuggestionsToBoards() async {
    final selectedBoards = _giftBoardCubit.state.mainGiftBoardState.selectedBoards ?? [];
    final suggestion = widget.giftSuggestions;

    if (selectedBoards.isEmpty || suggestion == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select boards and ensure a gift suggestion is available')));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saving suggestion to ${selectedBoards.length} board${selectedBoards.length > 1 ? 's' : ''}...'), duration: const Duration(seconds: 2)));

    try {
      for (final board in selectedBoards) {
        final boardGiftSuggestion = BoardGiftSuggestion(board: board, giftSuggestion: suggestion, createdAt: Timestamp.now());
        await _giftBoardCubit.createNewBoardGiftSuggestion(boardGiftSuggestion);

        await Future.delayed(const Duration(milliseconds: 100));
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully saved suggestion to ${selectedBoards.length} board${selectedBoards.length > 1 ? 's' : ''}!'), backgroundColor: Colors.green, duration: const Duration(seconds: 3)));
        Navigator.of(context).pop(selectedBoards);
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving suggestion: ${error.toString()}'), backgroundColor: Colors.red, duration: const Duration(seconds: 4)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GiftBoardCubit, GiftBoardState>(
      bloc: _giftBoardCubit,
      listener: (context, state) {
        if (state is CreatedGiftBoardSuggestion) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gift suggestion saved successfully!'), backgroundColor: Colors.green));
        } else if (state is GiftBoardError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${state.mainGiftBoardState.errorMessage ?? 'Something went wrong'}'), backgroundColor: Colors.red));
        }
      },
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text('Save to Boards', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  IconButton(icon: const Icon(Icons.close, size: 24.0), onPressed: () => Navigator.of(context).pop()),
                ],
              ),
              const SizedBox(height: 16),

              BlocBuilder<GiftBoardCubit, GiftBoardState>(
                bloc: _giftBoardCubit,
                builder: (context, state) {
                  final boards = state.mainGiftBoardState.allUserGiftBoards ?? [];
                  final selectedBoards = state.mainGiftBoardState.selectedBoards ?? [];
                  final hasSelection = selectedBoards.isNotEmpty;
                  final isLoading = state is LoadingGiftBoards;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (isLoading)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else if (state is GiftBoardError)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Text(state.mainGiftBoardState.errorMessage ?? 'Something went wrong.', style: TextStyle(color: Colors.red.shade600)),
                        )
                      else if (boards.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Center(child: Text('No boards available', style: Theme.of(context).textTheme.bodyMedium)),
                        )
                      else
                        Container(
                          constraints: const BoxConstraints(maxHeight: 300),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: boards.length,
                            itemBuilder: (context, index) {
                              final board = boards[index];
                              final isSelected = selectedBoards.any((b) => b.uid == board.uid);

                              return CheckboxListTile(
                                value: isSelected,
                                onChanged: (_) => _giftBoardCubit.toggleBoardSelection(board),
                                title: Text((board.boardName ?? 'Unnamed Board').trim(), maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyLarge),
                                subtitle: Text('Board', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
                                secondary: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: AppColors.pinkLavender,
                                  child: (board.thumbnailUrl?.isNotEmpty ?? false)
                                      ? ClipOval(
                                          child: SizedBox(
                                            width: 45,
                                            height: 45,
                                            child: DunnoExtendedImage(url: board.thumbnailUrl!, fit: BoxFit.cover),
                                          ),
                                        )
                                      : const Icon(Icons.dashboard, color: Colors.white, size: 20),
                                ),
                                controlAffinity: ListTileControlAffinity.trailing,
                                activeColor: AppColors.cerise,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                              );
                            },
                          ),
                        ),

                      const SizedBox(height: 20),

                      // Save button
                      DunnoButton(type: hasSelection ? ButtonType.saffron : ButtonType.pinkLavender, isDisabled: !hasSelection, label: hasSelection ? 'Save to ${selectedBoards.length} board${selectedBoards.length > 1 ? 's' : ''}' : 'Select a board to save', onPressed: hasSelection ? _saveSuggestionsToBoards : null),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
