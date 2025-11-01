import 'package:flutter/material.dart';

class GiftBoardSuggestions extends StatefulWidget {
  const GiftBoardSuggestions({super.key});

  @override
  State<GiftBoardSuggestions> createState() => _GiftBoardSuggestionsState();
}

class _GiftBoardSuggestionsState extends State<GiftBoardSuggestions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gift Board Suggestions')),
      body: const Center(
        child: Text('Gift Board Suggestions Screen'),
      ),
    );
  }
}
