import 'package:dunno/constants/themes.dart';
import 'package:dunno/models/collection_likes.dart';
import 'package:dunno/models/quick_suggestion.dart';
import 'package:dunno/ui/widgets/dunno_dropdown_field.dart';
import 'package:dunno/ui/widgets/dunno_text_field.dart';
import 'package:flutter/material.dart';

class AddProfileDetailsPage extends StatefulWidget {
  final Function(QuickSuggestion)? onProfileUpdated;

  const AddProfileDetailsPage({super.key, this.onProfileUpdated});

  @override
  State<AddProfileDetailsPage> createState() => _AddProfileDetailsPageState();
}

class _AddProfileDetailsPageState extends State<AddProfileDetailsPage> {
  final _extraNotesController = TextEditingController();
  final _ageController = TextEditingController();
  final _likesController = TextEditingController();
  final _hobbiesController = TextEditingController();
  final _interestsController = TextEditingController();

  String? _eventType;
  GenderType? _gender;
  String? _extraNotes;
  int? _age;
  List<String> _likes = [];
  List<String> _hobbies = [];
  List<String> _interests = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Type Dropdown
            DunnoDropdownField<String>(
              label: 'What\'s the occasion?',
              hintText: 'Select occasion',
              value: _eventType,
              onChanged: (value) {
                setState(() {
                  _eventType = value;
                });
                _updateProfile();
              },
              dropDownColor: AppColors.offWhite,
              dropDownTextColor: AppColors.black,
              items:
                  [
                    'Birthday',
                    'Anniversary',
                    'Wedding',
                    'Graduation',
                    'Holiday',
                    'Valentine\'s Day',
                    'Mother\'s Day',
                    'Father\'s Day',
                    'Christmas',
                    'Just Because',
                    'Other',
                  ].map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(
                        type,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.black,
                        ),
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 16),

            // Gender Dropdown
            DunnoDropdownField<GenderType>(
              label: 'Who are you shopping for?',
              hintText: 'Select gender',
              value: _gender,
              onChanged: (value) {
                setState(() {
                  _gender = value;
                });
                _updateProfile();
              },
              dropDownColor: AppColors.offWhite,
              dropDownTextColor: AppColors.black,
              items: GenderType.values.map((gender) {
                return DropdownMenuItem<GenderType>(
                  value: gender,
                  child: Text(
                    _getGenderDisplayName(gender),
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge?.copyWith(color: AppColors.black),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Age Field
            DunnoTextField(
              controller: _ageController,
              label: 'Age (optional)',
              keyboardType: TextInputType.number,
              isLight: true,
              colorScheme: DunnoTextFieldColor.antiqueWhite,
              onChanged: (value) {
                _age = int.tryParse(value);
                _updateProfile();
              },
            ),
            const SizedBox(height: 16),

            // Interests Field
            DunnoTextField(
              controller: _interestsController,
              label: 'What are their interests?',
              supportingText: 'e.g., Photography, Reading, Cooking',
              keyboardType: TextInputType.text,
              isLight: true,
              colorScheme: DunnoTextFieldColor.antiqueWhite,
              maxLines: 2,
              onChanged: (value) {
                _interests = value
                    .split(',')
                    .map((String e) => e.trim())
                    .where((String e) => e.isNotEmpty)
                    .toList();
                _updateProfile();
              },
            ),
            const SizedBox(height: 16),

            // Hobbies Field
            DunnoTextField(
              controller: _hobbiesController,
              label: 'What are their hobbies?',
              supportingText: 'e.g., Gaming, Gardening, Sports',
              keyboardType: TextInputType.text,
              isLight: true,
              colorScheme: DunnoTextFieldColor.antiqueWhite,
              maxLines: 2,
              onChanged: (value) {
                _hobbies = value
                    .split(',')
                    .map((String e) => e.trim())
                    .where((String e) => e.isNotEmpty)
                    .toList();
                _updateProfile();
              },
            ),
            const SizedBox(height: 16),

            // Likes Field
            DunnoTextField(
              controller: _likesController,
              label: 'What do they like?',
              supportingText: 'e.g., Coffee, Books, Technology',
              keyboardType: TextInputType.text,
              isLight: true,
              colorScheme: DunnoTextFieldColor.antiqueWhite,
              maxLines: 2,
              onChanged: (value) {
                _likes = value
                    .split(',')
                    .map((String e) => e.trim())
                    .where((String e) => e.isNotEmpty)
                    .toList();
                _updateProfile();
              },
            ),
            const SizedBox(height: 16),

            // Extra Notes Field
            DunnoTextField(
              controller: _extraNotesController,
              label: 'Any extra notes?',
              supportingText: 'Additional details about the person or occasion',
              keyboardType: TextInputType.text,
              isLight: true,
              colorScheme: DunnoTextFieldColor.antiqueWhite,
              maxLines: 3,
              onChanged: (value) {
                _extraNotes = value;
                _updateProfile();
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  String _getGenderDisplayName(GenderType gender) {
    switch (gender) {
      case GenderType.woman:
        return 'Woman';
      case GenderType.man:
        return 'Man';
      case GenderType.other:
        return 'Other';
    }
  }

  void _updateProfile() {
    final collectionLikes = CollectionLikes(
      interests: _interests,
      hobbies: _hobbies,
      likes: _likes,
    );

    final quickSuggestion = QuickSuggestion(
      eventType: _eventType,
      gender: _gender,
      age: _age,
      likes: collectionLikes,
      extraNotes: _extraNotes,
    );

    widget.onProfileUpdated?.call(quickSuggestion);
  }

  @override
  void dispose() {
    _extraNotesController.dispose();
    _ageController.dispose();
    _likesController.dispose();
    _hobbiesController.dispose();
    _interestsController.dispose();
    super.dispose();
  }
}
