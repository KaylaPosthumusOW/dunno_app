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

  const FriendGiftSuggestionManagement({super.key, this.friendData, this.collectionData});

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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill in filter preferences for suggestions'), backgroundColor: Colors.red));
      return;
    }

    context.pushNamed(FRIEND_GIFT_SUGGESTION_SCREEN, extra: {'friend': widget.friendData, 'collection': widget.collectionData, 'filters': _filterData?.toMap()});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        centerTitle: false,
        leadingWidth: 50,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back_rounded, size: 20, color: Colors.white),
            style: IconButton.styleFrom(backgroundColor: AppColors.cerise, shape: const CircleBorder(), minimumSize: const Size(36, 36), padding: EdgeInsets.zero),
          ),
        ),
        titleSpacing: 20,
        title: Text(
          'Gift Suggestion Preferences',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: AppColors.black),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: AddFilterPage(onFilterUpdated: _handleFilterData, isFriendFlow: true)),

          Padding(
            padding:  EdgeInsets.all(20),
            child: DunnoButton(type: ButtonType.primary, onPressed: _generateSuggestions, label: 'Generate Gift Suggestions'),
          ),
        ],
      ),
    );
  }
}
