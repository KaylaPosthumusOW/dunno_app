import 'package:dunno/constants/constants.dart';
import 'package:dunno/constants/themes.dart';
import 'package:dunno/cubits/gift_board/gift_board_cubit.dart';
import 'package:dunno/ui/screens/gift_boards/create_board_dialog.dart';
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

  Widget _displaySuggestions() {
    return BlocBuilder<GiftBoardCubit, GiftBoardState>(
      bloc: _giftBoardCubit,
      builder: (context, state) {
        if (state is LoadingGiftBoardSuggestion) {
          return const Center(child: CircularProgressIndicator());
        }

        final suggestions = state.mainGiftBoardState.allGiftBoardSuggestions ?? [];

        if (suggestions.isEmpty) {
          return Center(
            child: Text('No suggestions found.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.black)),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final suggestion = suggestions[index];
            return GiftSuggestionCard(suggestion: suggestion.giftSuggestion, index: index);
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _giftBoardCubit.loadAllBoardGiftSuggestionsForBoard(boardUid: _giftBoardCubit.state.mainGiftBoardState.selectedGiftBoard?.uid ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_giftBoardCubit.state.mainGiftBoardState.selectedGiftBoard?.boardName}'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert_rounded, color: AppColors.black),
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => CreateBoardDialog(),
                  );
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
                onTap: () {},
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: _displaySuggestions(),
        ),
      )
    );
  }
}
