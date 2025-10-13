import 'package:dunno/constants/themes.dart';
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
          const SizedBox(height: 16),
          const Align(
              alignment: Alignment.centerLeft,
              child: Text('Adjust your Budget', style: TextStyle(fontWeight: FontWeight.bold))),
          Slider(
            value: budget,
            min: 0,
            max: 1000,
            activeColor: AppColors.cerise,
            label: budget.toStringAsFixed(0),
            onChanged: (val) => setState(() => budget = val),
          ),
          _buildTextField('Decide on a Gift Type', (val) => giftType = val),
          _buildTextField('Decide on the value of the gift', (val) => giftValue = val),
          _buildTextField('What category gift', (val) => giftCategory = val),
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
