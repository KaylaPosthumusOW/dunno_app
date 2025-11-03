import 'package:dunno/constants/constants.dart';
import 'package:dunno/constants/themes.dart';
import 'package:dunno/cubits/general/general_cubit.dart';
import 'package:dunno/cubits/gift_board/gift_board_cubit.dart';
import 'package:dunno/models/ai_gift_suggestion.dart';
import 'package:dunno/ui/screens/gift_boards/selecting_gift_boards.dart';
import 'package:flutter/material.dart';

class GiftSuggestionCard extends StatefulWidget {
  final AiGiftSuggestion? suggestion;
  final int index;
  final bool isPink;
  final bool isSaved;

  const GiftSuggestionCard({super.key, required this.suggestion, required this.index, this.isPink = true, this.isSaved = false});

  @override
  State<GiftSuggestionCard> createState() => _GiftSuggestionCardState();
}

class _GiftSuggestionCardState extends State<GiftSuggestionCard> {
  final GeneralCubit _generalCubit = sl<GeneralCubit>();
  final GiftBoardCubit _giftBoardCubit = sl<GiftBoardCubit>();
  late bool _isSaved;

  @override
  void initState() {
    super.initState();
    _isSaved = widget.isSaved;
  }

  @override
  Widget build(BuildContext context) {
    final mainColor = widget.isPink ? AppColors.cerise : AppColors.cinnabar;
    final textColor = widget.isPink ? AppColors.cerise : AppColors.cinnabar;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: mainColor, offset: const Offset(3, 4))],
        border: Border.all(width: 1.5, color: mainColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    widget.suggestion?.title ?? '',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: textColor, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () async {
                    final result = await showDialog(
                      context: context,
                      builder: (context) {
                        _giftBoardCubit.clearBoardSelections();
                        return SelectingGiftBoards(giftSuggestions: widget.suggestion);
                      },
                    );

                    if (result != null && result is List && result.isNotEmpty) {
                      setState(() {
                        _isSaved = true;
                      });
                    }
                  },
                  child: Icon(_isSaved ? Icons.bookmark_add_rounded : Icons.bookmark_add_outlined, color: _isSaved ? Colors.amber : Colors.black54, size: 30),
                ),
              ],
            ),
            Text(
              'WHY?',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: textColor),
            ),
            Text(widget.suggestion?.reason ?? '', style: const TextStyle(fontSize: 14, color: Colors.grey, height: 1.5)),

            Text(
              'WHERE?',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: textColor),
            ),
            Row(
              children: [
                Text(widget.suggestion?.location != null ? '${widget.suggestion!.location}:' : '', style: const TextStyle(fontSize: 14, color: Colors.grey, height: 1.5)),
                SizedBox(width: 6),
                if ((widget.suggestion?.purchaseLink ?? '').isNotEmpty) ...[
                  const SizedBox(height: 6),
                  InkWell(
                    onTap: () => _generalCubit.openWebsite(url: widget.suggestion?.purchaseLink ?? ''),
                    child: Text(
                      'Link',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14, decoration: TextDecoration.underline, fontWeight: FontWeight.w600, height: 1.5),
                    ),
                  ),
                ],
              ],
            ),

            if ((widget.suggestion?.tags ?? []).isNotEmpty) ...[
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (widget.suggestion?.tags ?? [])
                    .map(
                      (tag) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: mainColor, borderRadius: BorderRadius.circular(16)),
                        child: Text(
                          tag,
                          style: TextStyle(fontSize: 12, color: AppColors.antiqueWhite, fontWeight: FontWeight.w500),
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
                      const Icon(Icons.category_outlined, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        widget.suggestion?.category ?? '',
                        style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  if ((widget.suggestion?.estimatedPrice ?? 0) > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: mainColor.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        'R${(widget.suggestion?.estimatedPrice ?? 0).toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: textColor, fontWeight: FontWeight.w700),
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
