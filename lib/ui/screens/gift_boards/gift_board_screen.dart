import 'package:flutter/material.dart';

class GiftBoardScreen extends StatefulWidget {
  const GiftBoardScreen({super.key});

  @override
  State<GiftBoardScreen> createState() => _GiftBoardScreenState();
}

class _GiftBoardScreenState extends State<GiftBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gift Board'),
      ),
      body: const Center(
        child: Text('This is the Gift Board Screen'),
      ),
    );
  }
}
