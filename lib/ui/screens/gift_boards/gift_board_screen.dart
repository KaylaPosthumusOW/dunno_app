import 'package:dunno/constants/constants.dart';
import 'package:dunno/constants/themes.dart';
import 'package:dunno/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:dunno/cubits/gift_board/gift_board_cubit.dart';
import 'package:dunno/ui/screens/gift_boards/create_board_dialog.dart';
import 'package:dunno/ui/widgets/dunno_button.dart';
import 'package:dunno/ui/widgets/dunno_search_field.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gift Board')),
      body: BlocBuilder<GiftBoardCubit, GiftBoardState>(
        bloc: _giftBoardCubit,
        builder: (context, state) {
          return SingleChildScrollView(
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
                      SizedBox(width: 10),
                      DunnoButton(
                        label: 'Create',
                        type: ButtonType.primary,
                        icon: Icon(Icons.add, color: Colors.white),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const CreateBoardDialog();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: state.mainGiftBoardState.allUserGiftBoards?.length,
                    itemBuilder: (context, index) {
                      final board = state.mainGiftBoardState.allUserGiftBoards![index];
                      return Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: AppColors.offWhite,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.yellow, width: 1.5),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: AppColors.yellow,
                              child: Icon(Icons.dashboard, color: Colors.white),
                            ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  board.boardName ?? 'Unnamed Board',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Items:',
                                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
