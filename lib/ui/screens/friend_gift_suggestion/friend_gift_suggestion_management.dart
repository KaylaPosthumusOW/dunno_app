import 'package:dunno/constants/routes.dart';
import 'package:dunno/constants/themes.dart';
import 'package:dunno/models/filter_suggestion.dart';
import 'package:dunno/ui/screens/quick_gift_suggestion/add_filter_screen.dart';
import 'package:dunno/ui/widgets/custom_header_bar.dart';
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
      body: Column(
        children: [
          CustomHeaderBar(
            title: 'Fine-tune Preferences',
            subtitle: 'Fine-tune your friend’s likes to help Dunno find the perfect gift match',
            onBack: () => Navigator.of(context).maybePop(),
            backButtonColor: AppColors.cerise,
            iconColor: AppColors.offWhite,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: AddFilterPage(onFilterUpdated: _handleFilterData, isFriendFlow: true)),

          Padding(
            padding:  EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: DunnoButton(type: ButtonType.primary, onPressed: _generateSuggestions, label: 'Generate Gift Suggestions'),
          ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
