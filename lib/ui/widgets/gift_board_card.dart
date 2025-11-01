import 'package:dunno/constants/routes.dart';
import 'package:dunno/constants/themes.dart';
import 'package:dunno/models/gift_boards.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GiftBoardCard extends StatefulWidget {
  final GiftBoard board;

  const GiftBoardCard({super.key, required this.board});

  @override
  State<GiftBoardCard> createState() => _GiftBoardCardState();
}

class _GiftBoardCardState extends State<GiftBoardCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushNamed(GIFT_BOARDS_SUGGESTIONS_SCREEN);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.offWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.yellow, width: 1.5),
          boxShadow: [BoxShadow(color: AppColors.yellow, offset: const Offset(3, 4))],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.yellow,
              child: const Icon(Icons.dashboard, color: Colors.white),
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
                  const SizedBox(height: 4),
                  Text('Items:', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 18, color: AppColors.yellow),
          ],
        ),
      ),
    );
  }
}
