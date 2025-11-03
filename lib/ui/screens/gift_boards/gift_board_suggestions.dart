import 'package:dunno/constants/constants.dart';
import 'package:dunno/constants/themes.dart';
import 'package:dunno/cubits/gift_board/gift_board_cubit.dart';
import 'package:dunno/ui/screens/gift_boards/create_board_dialog.dart';
import 'package:dunno/ui/widgets/custom_header_bar.dart';
import 'package:dunno/ui/widgets/gift_suggestion_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GiftBoardSuggestions extends StatefulWidget {
  const GiftBoardSuggestions({super.key});

  @override
  State<GiftBoardSuggestions> createState() => _GiftBoardSuggestionsState();
}

class _GiftBoardSuggestionsState extends State<GiftBoardSuggestions> {
  final GiftBoardCubit _giftBoardCubit = sl<GiftBoardCubit>();

  Widget _boardHeader(GiftBoardState state) {
    final board = state.mainGiftBoardState.selectedGiftBoard;
    final count = state.mainGiftBoardState.allGiftBoardSuggestions?.length ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 80,
          backgroundColor: AppColors.pinkLavender,
          backgroundImage: (board?.thumbnailUrl != null && board!.thumbnailUrl!.isNotEmpty) ? NetworkImage(board.thumbnailUrl!) : null,
          child: (board?.thumbnailUrl == null || board!.thumbnailUrl!.isEmpty) ? Icon(Icons.dashboard, color: AppColors.cerise) : null,
        ),
        SizedBox(height: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              (board?.boardName ?? 'Unnamed Board').trim().isNotEmpty ? board!.boardName! : 'Unnamed Board',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text('$count item${count == 1 ? '' : 's'}', style: const TextStyle(fontSize: 13, color: Colors.black54)),
          ],
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _giftBoardCubit.loadAllBoardGiftSuggestionsForBoard(boardUid: _giftBoardCubit.state.mainGiftBoardState.selectedGiftBoard?.uid ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GiftBoardCubit, GiftBoardState>(
      bloc: _giftBoardCubit,
      builder: (context, state) {
        final suggestions = state.mainGiftBoardState.allGiftBoardSuggestions ?? [];

        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                CustomHeaderBar(
                  backButtonColor: AppColors.pinkLavender,
                  iconColor: AppColors.cerise,
                  onBack: () => Navigator.pop(context),
                  actions: [
                    PopupMenuButton(
                      icon: Icon(Icons.more_vert_rounded, color: AppColors.black),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          onTap: () {
                            showDialog(context: context, builder: (context) => CreateBoardDialog());
                          },
                          child: ListTile(
                            title: Row(
                              children: [
                                Icon(Icons.edit, color: AppColors.pinkLavender, size: 20),
                                SizedBox(width: 10),
                                Text('Edit Board'),
                              ],
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () {
                            _giftBoardCubit.deleteGiftBoard(boardUid: state.mainGiftBoardState.selectedGiftBoard?.uid ?? '');
                            Navigator.pop(context);
                          },
                          child: ListTile(
                            title: Row(
                              children: [
                                Icon(Icons.delete, color: Colors.red, size: 20),
                                SizedBox(width: 10),
                                Text('Delete Gift Board'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: _boardHeader(state),
                ),
            
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: suggestions.isEmpty
                      ? Column(
                    children: const [
                      SizedBox(height: 30),
                      Icon(Icons.card_giftcard_rounded, size: 45),
                      SizedBox(height: 20),
                      Text('No gift suggestions found.'),
                    ],
                  )
                      : ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: suggestions.length,
                    itemBuilder: (context, index) {
                      final s = suggestions[index];
                      return GiftSuggestionCard(
                        suggestion: s.giftSuggestion,
                        index: index,
                        isSaved: true,
                      );
                    },
                  ),
                ),
                SizedBox(height: 20,)
              ],
            ),
          ),
        );
      },
    );
  }
}
