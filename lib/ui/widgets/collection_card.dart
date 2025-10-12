import 'package:dunno/constants/constants.dart';
import 'package:dunno/constants/routes.dart';
import 'package:dunno/constants/themes.dart';
import 'package:dunno/cubits/collections/collection_cubit.dart';
import 'package:dunno/models/collections.dart';
import 'package:dunno/ui/widgets/dunno_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sp_utilities/utilities.dart';

class CollectionCard extends StatefulWidget {
  final bool? isPink;
  final Collections? collection;

  const CollectionCard({super.key, this.collection, this.isPink = false});

  @override
  State<CollectionCard> createState() => _CollectionCardState();
}

class _CollectionCardState extends State<CollectionCard> {
  final CollectionCubit _collectionCubit = sl<CollectionCubit>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.offWhite,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: widget.isPink == true ? AppColors.cerise : AppColors.cinnabar,
              offset: const Offset(3, 4),
            ),
          ],
          border: Border.all(width: 1.5, color: widget.isPink == true ? AppColors.cerise : AppColors.cinnabar)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.collection?.title ?? '', style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: widget.isPink == true ? AppColors.cerise : AppColors.cinnabar)),
            Text('Date: ${StringHelpers.printFirebaseTimeStamp(widget.collection?.createdAt, format: 'dd MMMM, yyyy')}', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.black)),
            SizedBox(height: 10),
            DunnoButton(
              label: 'View Collection',
              type: widget.isPink == true ? ButtonType.primary : ButtonType.secondary,
              onPressed: () {
                _collectionCubit.setSelectedCollection(widget.collection ?? Collections());
                context.pushNamed(COLLECTION_DETAIL_SCREEN);
              },
            )
          ],
        ),
      ),
    );
  }
}
