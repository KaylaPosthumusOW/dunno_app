import 'package:dunno/constants/constants.dart';
import 'package:dunno/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:dunno/cubits/gift_board/gift_board_cubit.dart';
import 'package:dunno/models/gift_boards.dart';
import 'package:dunno/ui/widgets/dunno_button.dart';
import 'package:dunno/ui/widgets/dunno_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateBoardDialog extends StatefulWidget {
  const CreateBoardDialog({super.key});

  @override
  State<CreateBoardDialog> createState() => _CreateBoardDialogState();
}

class _CreateBoardDialogState extends State<CreateBoardDialog> {
  final GiftBoardCubit _giftBoardCubit = sl<GiftBoardCubit>();
  final AppUserProfileCubit _appUserProfileCubit = sl<AppUserProfileCubit>();

  final TextEditingController _boardNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _boardNameController.text = _giftBoardCubit.state.mainGiftBoardState.selectedGiftBoard?.boardName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GiftBoardCubit, GiftBoardState>(
      bloc: _giftBoardCubit,
      builder: (context, state) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Create New Gift Board',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, size: 24.0),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                DunnoTextField(
                  controller: _boardNameController,
                  label: 'Board Name',
                  supportingText: 'Enter board name',
                  colorScheme: DunnoTextFieldColor.yellow,
                  isLight: true,
                ),
                SizedBox(height: 16.0),
                DunnoButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _giftBoardCubit.createNewBoard(
                      GiftBoard(
                        boardName: _boardNameController.text,
                        owner: _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile
                      ),
                    );
                  },
                  label: 'Create Board',
                  type: ButtonType.saffron,
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
