import 'package:dunno/constants/constants.dart';
import 'package:dunno/constants/themes.dart';
import 'package:dunno/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:dunno/cubits/gift_board/gift_board_cubit.dart';
import 'package:dunno/ui/screens/gift_boards/create_board_dialog.dart';
import 'package:dunno/ui/widgets/custom_header_bar.dart';
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
      body: Column(
        children: [
          CustomHeaderBar(
            title: 'Your Gift Boards',
            onBack: () => Navigator.pop(context),
            backButtonColor: AppColors.tangerine,
            iconColor: AppColors.offWhite,
            actions: [
              DunnoButton(
                label: 'Create Board',
                type: ButtonType.tangerine,
                icon: Icon(Icons.add, color: AppColors.offWhite),
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
          Expanded(
            child: BlocBuilder<GiftBoardCubit, GiftBoardState>(
              bloc: _giftBoardCubit,
              builder: (context, state) {
                final boards = state.mainGiftBoardState.searchedBoards ?? state.mainGiftBoardState.allUserGiftBoards ?? [];

                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          DunnoSearchField(
                            hintText: 'Search Your Boards',
                            typeSearch: TypeSearch.giftBoards,
                            controller: _searchCollection,
                            onChanged: (value) {
                              if (value.isEmpty) {
                                _giftBoardCubit.searchGiftBoards('', reset: true);
                              }
                              setState(() {});
                            },
                          ),
                          if (state is LoadingGiftBoards || state is SearchingGiftBoards)
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
                                  Text(_searchCollection.text.isNotEmpty ? 'No boards found matching "${_searchCollection.text}"' : 'No boards yet', style: Theme.of(context).textTheme.titleMedium),
                                  const SizedBox(height: 6),
                                  Text(
                                    _searchCollection.text.isNotEmpty ? 'Try adjusting your search terms' : 'Create your first Gift Board to save favourite ideas.',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.grey),
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
          ),
        ],
      ),
    );
  }
}
