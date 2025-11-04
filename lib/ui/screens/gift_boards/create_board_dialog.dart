import 'package:dunno/constants/constants.dart';
import 'package:dunno/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:dunno/cubits/gift_board/gift_board_cubit.dart';
import 'package:dunno/models/gift_boards.dart';
import 'package:dunno/ui/widgets/dunno_button.dart';
import 'package:dunno/ui/widgets/dunno_text_field.dart';
import 'package:dunno/ui/widgets/dunno_extended_image.dart';
import 'package:dunno/ui/widgets/dunno_image_uploading_tile.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_utilities/utilities.dart';

enum _ThumbnailSource { camera, gallery, remove }

class CreateBoardDialog extends StatefulWidget {
  const CreateBoardDialog({super.key});

  @override
  State<CreateBoardDialog> createState() => _CreateBoardDialogState();
}

class _CreateBoardDialogState extends State<CreateBoardDialog> {
  final GiftBoardCubit _giftBoardCubit = sl<GiftBoardCubit>();
  final AppUserProfileCubit _appUserProfileCubit = sl<AppUserProfileCubit>();

  final TextEditingController _boardNameController = TextEditingController();

  final SPFileUploaderCubit _spFileUploaderCubit = sl<SPFileUploaderCubit>();
  String _thumbnailUrl = '';

  Future<void> _chooseAndUploadThumbnail() async {
    final source = await showModalBottomSheet<_ThumbnailSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(3)),
            ),
            const SizedBox(height: 20),
            const Text('Add Board Thumbnail', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            if (_thumbnailUrl.isNotEmpty) ...[
              PopupMenuItem<_ThumbnailSource>(
                value: _ThumbnailSource.remove,
                child: const ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text('Remove Photo'),
                ),
                onTap: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) { });
                },
              ),
            ],
            PopupMenuItem<_ThumbnailSource>(
              value: _ThumbnailSource.camera,
              child: const ListTile(leading: Icon(Icons.camera_alt), title: Text('Take Photo')),
              onTap: () {
                WidgetsBinding.instance.addPostFrameCallback((_) {});
              },
            ),
            PopupMenuItem<_ThumbnailSource>(
              value: _ThumbnailSource.gallery,
              child: const ListTile(leading: Icon(Icons.photo_library), title: Text('Choose from Gallery')),
              onTap: () {
                WidgetsBinding.instance.addPostFrameCallback((_) {});
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );

    if (source == null) return;
    if (!mounted) return;

    if (source == _ThumbnailSource.remove) {
      setState(() {
        _thumbnailUrl = '';
      });
      return;
    }

    final storageReference = sl<FirebaseStorage>().ref().child('gift_boards').child('thumbnails').child(_appUserProfileCubit.state.mainAppUserProfileState.appUserProfile!.uid!).child('${DateTime.now().millisecondsSinceEpoch}');

    try {
      if (source == _ThumbnailSource.camera) {
        _spFileUploaderCubit.singleSelectImageFromCameraToUploadToReference(storageRef: storageReference);
      } else {
        _spFileUploaderCubit.singleSelectImageFromGalleryToUploadToReference(storageRef: storageReference);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
    }
  }

  Widget _thumbnailPicture() {
    return BlocConsumer<SPFileUploaderCubit, SPFileUploaderState>(
      bloc: _spFileUploaderCubit,
      listener: (context, state) {
        if (state is SPFileUploaderAllUploadTaskCompleted) {
          final downloadUrl = state.mainSPFileUploadState.downloadUrls?.first;
          if (mounted && downloadUrl != null) {
            setState(() {
              _thumbnailUrl = downloadUrl;
            });
          }
        }
        if (state is SPFileUploaderErrorState) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.mainSPFileUploadState.errorMessage ?? state.mainSPFileUploadState.message ?? 'Upload error')));
          }
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: _chooseAndUploadThumbnail,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: _thumbnailUrl.isNotEmpty
                  ? DunnoExtendedImage(url: _thumbnailUrl)
                  : state.mainSPFileUploadState.uploadTasks != null && state.mainSPFileUploadState.uploadTasks!.isNotEmpty
                  ? DunnoImageUploadingTile(task: state.mainSPFileUploadState.uploadTasks!.first, size: 120.0, isCircular: true)
                  : Container(
                      color: Colors.grey[300],
                      child: Icon(Icons.add_photo_alternate, size: 40, color: Colors.grey[600]),
                    ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    final selectedBoard = _giftBoardCubit.state.mainGiftBoardState.selectedGiftBoard;
    _boardNameController.text = selectedBoard?.boardName ?? '';
    _thumbnailUrl = selectedBoard?.thumbnailUrl ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GiftBoardCubit, GiftBoardState>(
      bloc: _giftBoardCubit,
      builder: (context, state) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Create New Gift Board', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Icon(Icons.close, size: 24.0),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                DunnoTextField(controller: _boardNameController, label: 'Board Name', supportingText: 'Enter board name', colorScheme: DunnoTextFieldColor.yellow, isLight: true),
                SizedBox(height: 20.0),
                Center(
                  child: Column(
                    children: [
                      Text('Board Thumbnail', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      SizedBox(height: 12.0),
                      _thumbnailPicture(),
                      SizedBox(height: 8.0),
                      Text('Tap to add a thumbnail image', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                ),
                SizedBox(height: 16.0),
                DunnoButton(
                  onPressed: () {
                    final boardName = _boardNameController.text.trim();
                    
                    // Safety check: ensure board name is not empty
                    if (boardName.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a board name'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    
                    Navigator.of(context).pop();
                    _giftBoardCubit.createNewBoard(GiftBoard(boardName: boardName, owner: _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile, thumbnailUrl: _thumbnailUrl.isNotEmpty ? _thumbnailUrl : null));
                  },
                  label: 'Create Board',
                  type: ButtonType.saffron,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _boardNameController.dispose();
    super.dispose();
  }
}
