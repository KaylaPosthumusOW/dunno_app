import 'package:dunno/constants/themes.dart';
import 'package:dunno/models/ai_gift_suggestion.dart';
import 'package:flutter/material.dart';

class GiftSuggestionCard extends StatefulWidget {
  final AiGiftSuggestion? suggestion;
  final int index;
  final bool isPink;

  const GiftSuggestionCard({
    super.key,
    required this.suggestion,
    required this.index,
    this.isPink = true,
  });

  @override
  State<GiftSuggestionCard> createState() => _GiftSuggestionCardState();
}

class _GiftSuggestionCardState extends State<GiftSuggestionCard> {
  @override
  Widget build(BuildContext context) {
    final mainColor = widget.isPink ? AppColors.cerise : AppColors.cinnabar;
    final textColor = widget.isPink ? AppColors.cerise : AppColors.cinnabar;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: mainColor,
            offset: const Offset(3, 4),
          ),
        ],
        border: Border.all(width: 1.5, color: mainColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    widget.suggestion?.title ?? '',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Icon(Icons.bookmark_add_outlined)
              ],
            ),
            Text(
              'WHY?',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            Text(
              widget.suggestion?.reason ?? '',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                height: 1.5,
              ),
            ),
            if ((widget.suggestion?.tags ?? []).isNotEmpty) ...[
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (widget.suggestion?.tags ?? [])
                    .map(
                      (tag) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.antiqueWhite,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
                    .toList(),
              ),
            ],
            if ((widget.suggestion?.category ?? '').isNotEmpty) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.category_outlined,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.suggestion?.category ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  if ((widget.suggestion?.estimatedPrice ?? 0) > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: mainColor.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'R${(widget.suggestion?.estimatedPrice ?? 0).toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
