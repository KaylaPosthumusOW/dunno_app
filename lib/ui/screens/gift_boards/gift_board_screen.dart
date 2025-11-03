import 'package:dunno/constants/constants.dart';
import 'package:dunno/constants/themes.dart';
import 'package:dunno/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:dunno/cubits/gift_board/gift_board_cubit.dart';
import 'package:dunno/ui/screens/gift_boards/create_board_dialog.dart';
import 'package:dunno/ui/widgets/dunno_button.dart';
import 'package:dunno/ui/widgets/dunno_search_field.dart';
import 'package:dunno/ui/widgets/gift_board_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GiftBoardScreen extends StatefulWidget {
  const GiftBoardScreen({super.key});

  @override
  State<GiftBoardScreen> createState() => _GiftBoardScreenState();
}

class _GiftBoardScreenState extends State<GiftBoardScreen> {
  final GiftBoardCubit _giftBoardCubit = sl<GiftBoardCubit>();
  final AppUserProfileCubit _appUserProfileCubit = sl<AppUserProfileCubit>();

  final TextEditingController _searchCollection = TextEditingController();

  @override
  void initState() {
    super.initState();
    _giftBoardCubit.loadAllUserGiftBoards(ownerUid: _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile?.uid ?? '');
  }

  @override
  void dispose() {
    _searchCollection.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await _giftBoardCubit.loadAllUserGiftBoards(ownerUid: _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile?.uid ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gift Board')),
      body: BlocBuilder<GiftBoardCubit, GiftBoardState>(
        bloc: _giftBoardCubit,
        builder: (context, state) {
          final boards = state.mainGiftBoardState.allUserGiftBoards ?? [];

          return RefreshIndicator(
            onRefresh: _refresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: DunnoSearchField(hintText: 'Search Your Boards', typeSearch: TypeSearch.collections, controller: _searchCollection),
                        ),
                        const SizedBox(width: 10),
                        DunnoButton(
                          label: 'Create',
                          type: ButtonType.pinkLavender,
                          icon: Icon(Icons.add, color: AppColors.cerise),
                          onPressed: () {
                            _giftBoardCubit.clearSelectedGiftBoard();
                            showDialog(
                              context: context,
                              builder: (context) {
                                return CreateBoardDialog();
                              },
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    if (state is LoadingGiftBoards)
                      const Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (boards.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Column(
                          children: [
                            const Icon(Icons.dashboard_outlined, size: 48, color: Colors.grey),
                            const SizedBox(height: 12),
                            Text('No boards yet', style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 6),
                            const Text(
                              'Create your first Gift Board to save favourite ideas.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: boards.length,
                        itemBuilder: (context, index) {
                          final board = boards[index];
                          return GiftBoardCard(board: board);
                        },
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
