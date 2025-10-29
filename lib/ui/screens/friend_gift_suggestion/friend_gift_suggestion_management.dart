import 'package:dunno/constants/routes.dart';
import 'package:dunno/constants/themes.dart';
import 'package:dunno/models/filter_suggestion.dart';
import 'package:dunno/ui/screens/quick_gift_suggestion/add_filter_screen.dart';
import 'package:dunno/ui/widgets/dunno_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FriendGiftSuggestionManagement extends StatefulWidget {
  final Map<String, dynamic>? friendData;
  final Map<String, dynamic>? collectionData;
  
  const FriendGiftSuggestionManagement({
    super.key,
    this.friendData,
    this.collectionData,
  });

  @override
  State<FriendGiftSuggestionManagement> createState() => _FriendGiftSuggestionManagementState();
}

class _FriendGiftSuggestionManagementState extends State<FriendGiftSuggestionManagement> {
  FilterSuggestion? _filterData;

  void _handleFilterData(FilterSuggestion data) {
    setState(() {
      _filterData = data;
    });
  }

  void _generateSuggestions() {
    if (_filterData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill in filter preferences for suggestions',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Navigate to the friend gift suggestion screen with all the data
    context.pushNamed(
      FRIEND_GIFT_SUGGESTION_SCREEN,
      extra: {
        'friend': widget.friendData,
        'collection': widget.collectionData,
        'filters': _filterData?.toMap(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Gift Ideas for ${widget.friendData?['name'] ?? 'Friend'}',
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: AppColors.offWhite,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Set your gift preferences',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
          ),

          // Filter screen
          Expanded(
            child: AddFilterPage(onFilterUpdated: _handleFilterData),
          ),

          // Generate suggestions button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DunnoButton(
              type: ButtonType.cinnabar,
              onPressed: _generateSuggestions,
              label: 'Generate Gift Suggestions',
              buttonColor: AppColors.cinnabar,
              textColor: AppColors.offWhite,
            ),
          ),
        ],
      ),
    );
  }
}
