import 'package:dunno/constants/routes.dart';
import 'package:dunno/constants/themes.dart';
import 'package:dunno/models/collections.dart';
import 'package:dunno/ui/widgets/dunno_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sp_utilities/utilities.dart';

class CollectionCard extends StatefulWidget {
  final Collections? collection;

  const CollectionCard({super.key, this.collection});

  @override
  State<CollectionCard> createState() => _CollectionCardState();
}

class _CollectionCardState extends State<CollectionCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.offWhite,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.cerise,
              offset: const Offset(3, 4),
            ),
          ],
          border: Border.all(width: 1.5, color: AppColors.cerise)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.collection?.title ?? '', style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: AppColors.cerise)),
            Text('Date: ${StringHelpers.printFirebaseTimeStamp(widget.collection?.createdAt, format: 'dd MMMM, yyyy')}', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.black)),
            SizedBox(height: 10),
            DunnoButton(
              label: 'View Collection',
              type: ButtonType.primary,
              onPressed: () {
                context.pushNamed(COLLECTIONS_SCREEN);
              },
            )
          ],
        ),
      ),
    );
  }
}
