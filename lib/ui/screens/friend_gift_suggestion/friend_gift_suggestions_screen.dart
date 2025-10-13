import 'package:flutter/material.dart';

class FriendGiftSuggestionsScreen extends StatefulWidget {
  const FriendGiftSuggestionsScreen({super.key});

  @override
  State<FriendGiftSuggestionsScreen> createState() => _FriendGiftSuggestionsScreenState();
}

class _FriendGiftSuggestionsScreenState extends State<FriendGiftSuggestionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friend Gift Suggestions'),
      ),
      body: const Center(
        child: Text('Friend Gift Suggestions Screen'),
      ),
    );
  }
}
