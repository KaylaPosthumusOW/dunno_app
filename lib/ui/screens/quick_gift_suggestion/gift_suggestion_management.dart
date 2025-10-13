import 'package:dunno/constants/themes.dart';
import 'package:dunno/cubits/ai_gift_suggestion/ai_gift_suggestion_cubit.dart';
import 'package:dunno/models/filter_suggestion.dart';
import 'package:dunno/models/quick_suggestion.dart';
import 'package:dunno/ui/screens/quick_gift_suggestion/add_filter_screen.dart';
import 'package:dunno/ui/screens/quick_gift_suggestion/add_profile_details_screen.dart';
import 'package:dunno/ui/screens/quick_gift_suggestion/receive_gift_suggestion_screen.dart';
import 'package:dunno/ui/widgets/dunno_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class GiftSuggestionManagement extends StatefulWidget {
  const GiftSuggestionManagement({super.key});

  @override
  State<GiftSuggestionManagement> createState() =>
      _GiftSuggestionManagementState();
}

class _GiftSuggestionManagementState extends State<GiftSuggestionManagement> {
  int _selectedTab = 0;
  QuickSuggestion? _profileData;
  FilterSuggestion? _filterData;

  void _goToStep(int step) {
    setState(() {
      _selectedTab = step;
    });
  }

  void _handleProfileData(QuickSuggestion data) {
    setState(() {
      _profileData = data;
    });
  }

  void _handleFilterData(FilterSuggestion data) {
    setState(() {
      _filterData = data;
    });
  }

  void _generateSuggestions() {
    if (_profileData == null || _filterData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill in profile details and filter for suggestions',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (_) => GetIt.instance<AiGiftSuggestionCubit>(),
          child: ReceiveGiftSuggestionScreen(
            profile: _profileData!.toMap(),
            filters: _filterData!.toMap(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add Profile Details',
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Row(
              children: [
                _buildStepButton(
                  stepNumber: 1,
                  title: 'Profile',
                  isActive: _selectedTab == 0,
                  onTap: () => _goToStep(0),
                ),
                Expanded(
                  child: Divider(
                    color: _selectedTab == 1
                        ? AppColors.tangerine
                        : Colors.grey[300],
                    thickness: 2,
                  ),
                ),
                _buildStepButton(
                  stepNumber: 2,
                  title: 'Filter',
                  isActive: _selectedTab == 1,
                  onTap: () => _goToStep(1),
                ),
              ],
            ),
          ),

          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _selectedTab == 0
                  ? AddProfileDetailsPage(onProfileUpdated: _handleProfileData)
                  : AddFilterPage(onFilterUpdated: _handleFilterData),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                if (_selectedTab == 1)
                  Expanded(
                    flex: 1,
                    child: DunnoButton(
                      type: ButtonType.outlineCinnabar,
                      onPressed: () => _goToStep(0),
                      label: 'Back',
                    ),
                  ),
                if (_selectedTab == 1) const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: DunnoButton(
                    type: ButtonType.cinnabar,
                    onPressed: () {
                      if (_selectedTab == 0) {
                        _goToStep(1);
                      } else {
                        _generateSuggestions();
                      }
                    },
                    label: _selectedTab == 0 ? 'Next' : 'Generate Suggestions',
                    buttonColor: AppColors.cinnabar,
                    textColor: AppColors.offWhite,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepButton({
    required int stepNumber,
    required String title,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: isActive ? AppColors.cinnabar : Colors.grey[300],
              child: Text(
                '$stepNumber',
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              title,
              style: TextStyle(
                color: isActive ? AppColors.cinnabar : Colors.black54,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
