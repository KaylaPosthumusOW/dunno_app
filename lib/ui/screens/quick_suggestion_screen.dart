import 'package:flutter/material.dart';

class QuickSuggestionScreen extends StatefulWidget {
  const QuickSuggestionScreen({super.key});

  @override
  State<QuickSuggestionScreen> createState() => _QuickSuggestionScreenState();
}

class _QuickSuggestionScreenState extends State<QuickSuggestionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quick Suggestions'),
      ),
      body: const Center(
        child: Text('This is the Quick Suggestion Screen'),
      ),
    );
  }
}
