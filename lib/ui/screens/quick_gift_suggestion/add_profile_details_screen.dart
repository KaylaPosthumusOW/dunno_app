import 'package:dunno/constants/themes.dart';
import 'package:dunno/ui/widgets/dunno_dropdown_field.dart';
import 'package:dunno/ui/widgets/dunno_text_field.dart';
import 'package:flutter/material.dart';

class AddProfileDetailsPage extends StatefulWidget {
  const AddProfileDetailsPage({super.key});

  @override
  State<AddProfileDetailsPage> createState() => _AddProfileDetailsPageState();
}

class _AddProfileDetailsPageState extends State<AddProfileDetailsPage> {
  String? occasion;
  String? gender;
  String? likes;
  String? extraNotes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          DunnoDropdownField(
            label: 'Select',
            hintText: 'Select Analysis Type',
            value: null,
            onChanged: (type) {},
            dropDownColor: AppColors.offWhite,
            dropDownTextColor: AppColors.black,
            items: ['Birthday', 'Anniversary', 'Graduation', 'Holiday'].map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(
                  type,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 10),
          DunnoDropdownField(
            label: 'Select',
            hintText: 'Select Analysis Type',
            value: null,
            onChanged: (type) {},
            dropDownColor: AppColors.offWhite,
            dropDownTextColor: AppColors.black,
            items: ['Birthday', 'Anniversary', 'Graduation', 'Holiday'].map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(
                  type,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 10),
          DunnoDropdownField(
            label: 'Select',
            hintText: 'Select Analysis Type',
            value: null,
            onChanged: (type) {},
            dropDownColor: AppColors.offWhite,
            dropDownTextColor: AppColors.black,
            items: ['Birthday', 'Anniversary', 'Graduation', 'Holiday'].map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(
                  type,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          _buildNotesField(),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildNotesField() {
    return DunnoTextField(
      controller: TextEditingController(),
      label: 'Any extra notes?',
      keyboardType: TextInputType.text,
      isLight: true,
      colorScheme: DunnoTextFieldColor.antiqueWhite,
      maxLines: 3,
      onChanged: (val) => extraNotes = val,
    );
  }

  _setProfileDetails() {
    // Save or process the profile details as needed
  }
}