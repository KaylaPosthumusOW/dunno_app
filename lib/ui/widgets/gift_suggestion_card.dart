import 'package:dunno/constants/themes.dart';
import 'package:dunno/models/gift_suggestion.dart';
import 'package:flutter/material.dart';

class GiftSuggestionCard extends StatefulWidget {
  final GiftSuggestion? giftSuggestion;
  const GiftSuggestionCard({super.key, this.giftSuggestion});

  @override
  State<GiftSuggestionCard> createState() => _GiftSuggestionCardState();
}

class _GiftSuggestionCardState extends State<GiftSuggestionCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cerise,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.pinkLavender, offset: const Offset(3, 4))],
        border: Border.all(width: 1.5, color: AppColors.cerise),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Gift Title', style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: AppColors.offWhite)),
              Text('R000 - R000', style: Theme.of(context).textTheme.displayMedium?.copyWith(color: AppColors.offWhite)),
            ],
          ),
          SizedBox(height: 4),
          Text(
            'WHY?',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.offWhite, fontWeight: FontWeight.w900),
          ),
          Text('Gift Description goes here. Gift Description goes here. Gift Description goes here.', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.offWhite)),
          //List of categories it fits into in pill form
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: AppColors.pinkLavender, borderRadius: BorderRadius.circular(20)),
                child: Text(
                  'Category 1',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.cerise, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: AppColors.pinkLavender, borderRadius: BorderRadius.circular(20)),
                child: Text(
                  'Category 2',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.cerise, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'WHERE?',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.offWhite, fontWeight: FontWeight.w900),
          ),
          Text('Location of shop suggestion', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.offWhite)),
        ],
      ),
    );
  }
}
