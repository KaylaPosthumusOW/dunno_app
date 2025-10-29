import 'package:dunno/constants/themes.dart';
import 'package:dunno/models/ai_gift_suggestion.dart';
import 'package:flutter/material.dart';

class GiftSuggestionCard extends StatefulWidget {
  final AiGiftSuggestion? suggestion;
  final int index;

  const GiftSuggestionCard({
    super.key,
    required this.suggestion,
    required this.index,
  });

  @override
  State<GiftSuggestionCard> createState() => _GiftSuggestionCardState();
}

class _GiftSuggestionCardState extends State<GiftSuggestionCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: AppColors.offWhite,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.cinnabar,
              offset: const Offset(3, 4),
            ),
          ],
          border: Border.all(width: 1.5, color: AppColors.cinnabar)
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container(
                //   width: 32,
                //   height: 32,
                //   decoration: BoxDecoration(
                //     color: AppColors.cinnabar,
                //     shape: BoxShape.circle,
                //   ),
                //   child: Center(
                //     child: Text(
                //       '${widget.index + 1}',
                //       style: const TextStyle(
                //         color: Colors.white,
                //         fontWeight: FontWeight.bold,
                //         fontSize: 16,
                //       ),
                //     ),
                //   ),
                // ),
                // const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.suggestion?.title ?? '',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: AppColors.cinnabar,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                if ((widget.suggestion?.estimatedPrice ?? 0) > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.tangerine.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '\R${(widget.suggestion?.estimatedPrice ?? 0).toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.cinnabar, fontWeight: FontWeight.w700),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'WHY?',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: AppColors.cinnabar),
            ),
            Text(
              widget.suggestion?.reason ?? '',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                height: 1.5,
              ),
            ),
            // const SizedBox(height: 16),
            // Text(
            //   'Description',
            //   style: TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.w600,
            //     color: AppColors.black,
            //   ),
            // ),
            // // const SizedBox(height: 8),
            // // Text(
            // //   widget.suggestion?.description ?? '',
            // //   style: const TextStyle(
            // //     fontSize: 14,
            // //     color: Colors.grey,
            // //     height: 1.5,
            // //   ),
            // // ),
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
                          color: AppColors.cinnabar,
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
            ],
          ],
        ),
      ),
    );
  }
}
