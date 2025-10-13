import 'package:dunno/constants/themes.dart';
import 'package:dunno/ui/screens/friend_gift_suggestion/friend_gift_suggestions_screen.dart';
import 'package:dunno/ui/screens/quick_gift_suggestion/add_filter_screen.dart';
import 'package:dunno/ui/widgets/dunno_button.dart';
import 'package:flutter/material.dart';

class FriendGiftSuggestionManagement extends StatefulWidget {
  const FriendGiftSuggestionManagement({super.key});

  @override
  State<FriendGiftSuggestionManagement> createState() => _FriendGiftSuggestionManagementState();
}

class _FriendGiftSuggestionManagementState extends State<FriendGiftSuggestionManagement> {
  int _selectedTab = 0;

  void _goToStep(int step) {
    setState(() {
      _selectedTab = step;
    });
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
        title: Text('Add Profile Details',
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildStepButton(
                  stepNumber: 1,
                  title: 'Add Filter',
                  isActive: _selectedTab == 0,
                  onTap: () => _goToStep(0),
                ),

                Expanded(
                  child: Container(
                    height: 2,
                    color: _selectedTab == 1 ? AppColors.cerise : Colors.grey[300],
                  ),
                ),

                _buildStepButton(
                  stepNumber: 2,
                  title: 'Suggestions',
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
                  ? const AddFilterPage()
                  : const FriendGiftSuggestionsScreen(),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                if (_selectedTab == 1)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _goToStep(0),
                      child: const Text('Back'),
                    ),
                  ),
                if (_selectedTab == 1) const SizedBox(width: 12),
                Expanded(
                  child: DunnoButton(
                    type: ButtonType.primary,
                    onPressed: () {
                      if (_selectedTab == 0) {
                        _goToStep(1);
                      } else {
                        // TODO: Continue or save
                      }
                    },
                    label: _selectedTab == 0 ? 'Next' : 'Continue',
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
              backgroundColor: isActive ? AppColors.offWhite : Colors.grey[300],
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
                color: isActive ? AppColors.offWhite : Colors.black54,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
