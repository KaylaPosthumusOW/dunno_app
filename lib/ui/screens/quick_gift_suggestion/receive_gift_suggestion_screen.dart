import 'package:flutter/material.dart';

class ReceiveGiftSuggestionScreen extends StatefulWidget {
  const ReceiveGiftSuggestionScreen({super.key});

  @override
  State<ReceiveGiftSuggestionScreen> createState() => _ReceiveGiftSuggestionScreenState();
}

class _ReceiveGiftSuggestionScreenState extends State<ReceiveGiftSuggestionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receive Gift Suggestions'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {  },
          ),
        ],
      ),
      body: Center(
        child: Text('Receive Gift Suggestions Screen', style: Theme.of(context).textTheme.headlineMedium),
      ),
    );
  }
}
