import 'package:dunno/constants/themes.dart';
import 'package:dunno/ui/widgets/dunno_dropdown_field.dart';
import 'package:dunno/ui/widgets/dunno_text_field.dart';
import 'package:flutter/material.dart';

class AddFilterPage extends StatefulWidget {
  const AddFilterPage({super.key});

  @override
  State<AddFilterPage> createState() => _AddFilterPageState();
}

class _AddFilterPageState extends State<AddFilterPage> {
  double budget = 200;
  String? relation;
  String? giftType;
  String? giftValue;
  String? giftCategory;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildTextField('Who are you to the person?', (val) => relation = val),
          SizedBox(height: 10),
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 4, left: 15),
                child: Text('Adjust your Budget', style: TextStyle(fontWeight: FontWeight.bold)),
              )),
          Slider(
            value: budget,
            min: 0,
            max: 1000,
            activeColor: AppColors.tangerine,
            label: budget.toStringAsFixed(0),
            onChanged: (val) => setState(() => budget = val),
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
          const Spacer(),
          // _buildGenerateButton(),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DunnoTextField(
        controller: TextEditingController(),
        label: label,
        keyboardType: TextInputType.text,
        onChanged: onChanged,
        isLight: true,
        colorScheme: DunnoTextFieldColor.antiqueWhite,
      ),
    );
  }

  _setFilter() {
    // Implement filter logic here
  }
}
