import 'package:dunno/constants/constants.dart';
import 'package:dunno/constants/routes.dart';
import 'package:dunno/constants/themes.dart';
import 'package:dunno/cubits/gift_board/gift_board_cubit.dart';
import 'package:dunno/models/gift_boards.dart';
import 'package:dunno/ui/widgets/dunno_extended_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GiftBoardCard extends StatefulWidget {
  final GiftBoard board;

  const GiftBoardCard({super.key, required this.board});

  @override
  State<GiftBoardCard> createState() => _GiftBoardCardState();
}

class _GiftBoardCardState extends State<GiftBoardCard> {
  final GiftBoardCubit _giftBoardCubit = sl<GiftBoardCubit>();

  @override
  Widget build(BuildContext context) {
    final thumb = widget.board.thumbnailUrl;
    final hasThumb = thumb != null && thumb.trim().isNotEmpty;

    return InkWell(
      onTap: () {
        _giftBoardCubit.selectGiftBoard(widget.board);
        context.pushNamed(GIFT_BOARDS_SUGGESTIONS_SCREEN);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: AppColors.offWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.pinkLavender, width: 1.5),
          boxShadow: [BoxShadow(color: AppColors.pinkLavender, offset: const Offset(3, 4))],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.pinkLavender,
              child: ClipOval(
                child: hasThumb
                    ? SizedBox(
                  width: 48,
                  height: 48,
                  child: DunnoExtendedImage(
                    url: thumb,
                    fit: BoxFit.cover,
                  ),
                )
                    : Icon(Icons.dashboard, color: AppColors.offWhite, size: 24),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.board.boardName?.trim().isNotEmpty == true ? widget.board.boardName! : 'Unnamed Board',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 18, color: AppColors.pinkLavender),
          ],
        ),
      ),
    );
  }
}
