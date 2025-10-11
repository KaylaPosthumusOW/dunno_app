import 'package:flutter/material.dart';

class ViewAllCollectionsScreen extends StatefulWidget {
  const ViewAllCollectionsScreen({super.key});

  @override
  State<ViewAllCollectionsScreen> createState() => _ViewAllCollectionsScreenState();
}

class _ViewAllCollectionsScreenState extends State<ViewAllCollectionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Collections'),
      ),
      body: const Center(
        child: Text('View All Collections Screen'),
      ),
    );
  }
}
