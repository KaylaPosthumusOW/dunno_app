import 'package:dunno/constants/constants.dart';
import 'package:dunno/constants/routes.dart';
import 'package:dunno/constants/themes.dart';
import 'package:dunno/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:dunno/cubits/collections/collection_cubit.dart';
import 'package:dunno/models/collections.dart';
import 'package:dunno/ui/widgets/dunno_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sp_utilities/utilities.dart';

enum CollectionColorType { pink, orange, yellow }

class CollectionCard extends StatefulWidget {
  final CollectionColorType colorType;
  final Collections? collection;
  final Function? onPressed;

  const CollectionCard({super.key, this.collection, this.onPressed, this.colorType = CollectionColorType.pink});

  @override
  State<CollectionCard> createState() => _CollectionCardState();
}

class _CollectionCardState extends State<CollectionCard> {
  final AppUserProfileCubit _appUserProfileCubit = sl<AppUserProfileCubit>();
  final CollectionCubit _collectionCubit = sl<CollectionCubit>();

  Color get borderColor {
    switch (widget.colorType) {
      case CollectionColorType.pink:
        return AppColors.cerise;
      case CollectionColorType.orange:
        return AppColors.cinnabar;
      case CollectionColorType.yellow:
        return AppColors.yellow;
    }
  }

  ButtonType get buttonType {
    switch (widget.colorType) {
      case CollectionColorType.pink:
        return ButtonType.primary;
      case CollectionColorType.orange:
        return ButtonType.secondary;
      case CollectionColorType.yellow:
        return ButtonType.saffron;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserUid = _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile?.uid;
    final selectedProfileUid = _appUserProfileCubit.state.mainAppUserProfileState.selectedProfile?.uid;

    final bool isOwnProfile = (selectedProfileUid == null) || (selectedProfileUid == currentUserUid);

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.offWhite,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: borderColor, offset: const Offset(3, 4))],
          border: Border.all(width: 1.5, color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.collection?.title ?? '', style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: borderColor)),
            Text(
              'Date: ${StringHelpers.printFirebaseTimeStamp(widget.collection?.eventCollectionDate, format: 'dd MMMM, yyyy')}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.black),
            ),
            const SizedBox(height: 10),
            DunnoButton(
              label: isOwnProfile ? 'View Collection' : 'Create Gift Suggestion',
              type: buttonType,
              onPressed: () {
                _collectionCubit.setSelectedCollection(widget.collection ?? Collections());
                if (widget.onPressed != null) {
                  widget.onPressed!();
                } else {
                  context.pushNamed(COLLECTION_DETAIL_SCREEN);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
