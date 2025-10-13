import 'package:dunno/constants/themes.dart';
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
          _buildDropdown('What is the occasion?', ['Birthday', 'Anniversary', 'Christmas'], (value) {
            setState(() => occasion = value);
          }),
          _buildDropdown('Gender', ['Male', 'Female', 'Other'], (value) {
            setState(() => gender = value);
          }),
          _buildDropdown('Likes', ['Tech', 'Books', 'Fashion', 'Food'], (value) {
            setState(() => likes = value);
          }),
          const SizedBox(height: 10),
          _buildNotesField(),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: AppColors.antiqueWhite,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40), borderSide: BorderSide(color: AppColors.antiqueWhite))
        ),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
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