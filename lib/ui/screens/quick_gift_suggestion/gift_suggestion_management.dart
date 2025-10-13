import 'package:dunno/constants/themes.dart';
import 'package:dunno/ui/screens/quick_gift_suggestion/add_filter_screen.dart';
import 'package:dunno/ui/screens/quick_gift_suggestion/add_profile_details_screen.dart';
import 'package:dunno/ui/screens/quick_gift_suggestion/receive_gift_suggestion_screen.dart';
import 'package:dunno/ui/widgets/dunno_button.dart';
import 'package:flutter/material.dart';

class GiftSuggestionManagement extends StatefulWidget {
  const GiftSuggestionManagement({super.key});

  @override
  State<GiftSuggestionManagement> createState() =>
      _GiftSuggestionManagementState();
}

class _GiftSuggestionManagementState extends State<GiftSuggestionManagement> {
  int _selectedTab = 0;

  void _goToStep(int step) {
    setState(() {
      _selectedTab = step;
    });
  }

  Widget _buildCurrentStep() {
    switch (_selectedTab) {
      case 0:
        return const AddProfileDetailsPage();
      case 1:
        return const AddFilterPage();
      case 2:
        return const ReceiveGiftSuggestionScreen();
      default:
        return const SizedBox.shrink();
    }
  }

  String _getAppBarTitle() {
    switch (_selectedTab) {
      case 0:
        return 'Add Profile Details';
      case 1:
        return 'Add Filters';
      case 2:
        return 'Gift Suggestions';
      default:
        return '';
    }
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
          _getAppBarTitle(),
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
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
                    color: _selectedTab >= 1
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
                Expanded(
                  child: Divider(
                    color: _selectedTab == 2
                        ? AppColors.tangerine
                        : Colors.grey[300],
                    thickness: 2,
                  ),
                ),
                _buildStepButton(
                  stepNumber: 3,
                  title: 'Results',
                  isActive: _selectedTab == 2,
                  onTap: () => _goToStep(2),
                ),
              ],
            ),
          ),

          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildCurrentStep(),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                if (_selectedTab > 0)
                  Expanded(
                    flex: 1,
                    child: DunnoButton(
                      type: ButtonType.outlineCinnabar,
                      onPressed: () => _goToStep(_selectedTab - 1),
                      label: 'Back',
                    ),
                  ),
                if (_selectedTab > 0) const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: DunnoButton(
                    type: ButtonType.cinnabar,
                    onPressed: () {
                      if (_selectedTab == 0) {
                        _goToStep(1);
                      } else if (_selectedTab == 1) {
                        _goToStep(2);
                      } else {
                        _generateGiftSuggestions();
                      }
                    },
                    label: _selectedTab == 0
                        ? 'Next'
                        : _selectedTab == 1
                        ? 'Generate Suggestions'
                        : 'Finish',
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

  _generateGiftSuggestions() {
    // Implement your gift suggestion logic here
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
        padding: const EdgeInsets.symmetric(horizontal: 12),
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
