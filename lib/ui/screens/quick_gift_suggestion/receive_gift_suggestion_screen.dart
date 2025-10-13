import 'package:dunno/ui/widgets/gift_suggestion_card.dart';
import 'package:flutter/material.dart';

class ReceiveGiftSuggestionScreen extends StatefulWidget {
  const ReceiveGiftSuggestionScreen({super.key});

  @override
  State<ReceiveGiftSuggestionScreen> createState() => _ReceiveGiftSuggestionScreenState();
}

class _ReceiveGiftSuggestionScreenState extends State<ReceiveGiftSuggestionScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GiftSuggestionCard(),
            SizedBox(height: 10),
            GiftSuggestionCard(),
            SizedBox(height: 10),
            GiftSuggestionCard(),
          ],
        ),
      ),
    );
  }
}
