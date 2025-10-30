import 'package:dunno/constants/themes.dart';
import 'package:dunno/models/filter_suggestion.dart';
import 'package:dunno/ui/widgets/dunno_dropdown_field.dart';
import 'package:dunno/ui/widgets/dunno_text_field.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class AddFilterPage extends StatefulWidget {
  final Function(FilterSuggestion)? onFilterUpdated;
  final bool isFriendFlow;

  const AddFilterPage({
    super.key, 
    this.onFilterUpdated,
    this.isFriendFlow = false,
  });

  @override
  State<AddFilterPage> createState() => _AddFilterPageState();
}

class _AddFilterPageState extends State<AddFilterPage> {
  final _relationController = TextEditingController();
  final _giftTypeController = TextEditingController();
  final _extraNotesController = TextEditingController();

  double _minBudget = 200;
  double _maxBudget = 1000;
  String? _relation;
  String? _giftType;
  GiftValue? _giftValue;
  GiftCategory? _giftCategory;
  String? _extraNotes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DunnoTextField(
              controller: _relationController,
              label: 'What\'s your relationship to them?',
              supportingText: 'e.g., Friend, Sister, Colleague',
              keyboardType: TextInputType.text,
              isLight: true,
              colorScheme: widget.isFriendFlow 
                  ? DunnoTextFieldColor.pink 
                  : DunnoTextFieldColor.antiqueWhite,
              onChanged: (value) {
                _relation = value;
                _updateFilter();
              },
            ),
            const SizedBox(height: 20),

            // Budget Slider
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8, left: 15),
                child: Text(
                  'Budget: R${_minBudget.toStringAsFixed(0)} - R${_maxBudget.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SfRangeSlider(
              values: SfRangeValues(_minBudget, _maxBudget),
              min: 50.0,
              max: 5000.0,
              interval: 500,
              showLabels: true,
              activeColor: widget.isFriendFlow ? AppColors.cerise : AppColors.tangerine,
              inactiveColor: widget.isFriendFlow 
                  ? AppColors.cerise.withValues(alpha: 0.3)
                  : AppColors.tangerine.withValues(alpha: 0.3),
              startThumbIcon: Container(
                decoration: BoxDecoration(
                  color: widget.isFriendFlow ? AppColors.cerise : AppColors.tangerine,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
              endThumbIcon: Container(
                decoration: BoxDecoration(
                  color: widget.isFriendFlow ? AppColors.cerise : AppColors.tangerine,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
              tooltipTextFormatterCallback:
                  (dynamic actualValue, String formattedText) {
                    return 'R${actualValue.toStringAsFixed(0)}';
                  },
              labelFormatterCallback:
                  (dynamic actualValue, String formattedText) {
                    return 'R${(actualValue / 1000).toStringAsFixed(0)}k';
                  },
              onChanged: (SfRangeValues values) {
                setState(() {
                  _minBudget = values.start;
                  _maxBudget = values.end;
                });
                _updateFilter();
              },
            ),
            const SizedBox(height: 16),

            // Gift Category Dropdown
            DunnoDropdownField<GiftCategory>(
              label: 'Gift Category',
              hintText: 'Select category',
              value: _giftCategory,
              onChanged: (value) {
                setState(() {
                  _giftCategory = value;
                });
                _updateFilter();
              },
              fillColor: widget.isFriendFlow 
                  ? AppColors.pinkLavender.withValues(alpha: 0.6)
                  : AppColors.tangerine.withValues(alpha: 0.4),
              borderColor: widget.isFriendFlow 
                  ? AppColors.pinkLavender.withValues(alpha: 0.6)
                  : AppColors.antiqueWhite,
              focusedBorderColor: widget.isFriendFlow 
                  ? AppColors.pinkLavender
                  : AppColors.antiqueWhite,
              dropDownColor: AppColors.offWhite,
              dropDownTextColor: AppColors.black,
              items: GiftCategory.values.map((category) {
                return DropdownMenuItem<GiftCategory>(
                  value: category,
                  child: Text(
                    _getCategoryDisplayName(category),
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge?.copyWith(color: AppColors.black),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Gift Value Dropdown
            DunnoDropdownField<GiftValue>(
              label: 'Gift Value Type',
              hintText: 'Select value type',
              value: _giftValue,
              onChanged: (value) {
                setState(() {
                  _giftValue = value;
                });
                _updateFilter();
              },
              fillColor: widget.isFriendFlow 
                  ? AppColors.pinkLavender.withValues(alpha: 0.6)
                  : AppColors.tangerine.withValues(alpha: 0.4),
              borderColor: widget.isFriendFlow 
                  ? AppColors.pinkLavender.withValues(alpha: 0.6)
                  : AppColors.antiqueWhite,
              focusedBorderColor: widget.isFriendFlow 
                  ? AppColors.pinkLavender
                  : AppColors.antiqueWhite,
              dropDownColor: AppColors.offWhite,
              dropDownTextColor: AppColors.black,
              items: GiftValue.values.map((value) {
                return DropdownMenuItem<GiftValue>(
                  value: value,
                  child: Text(
                    _getValueDisplayName(value),
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge?.copyWith(color: AppColors.black),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Gift Type Field
            DunnoTextField(
              controller: _giftTypeController,
              label: 'Type of gift?',
              supportingText: 'e.g., Practical, Sentimental, Fun',
              keyboardType: TextInputType.text,
              isLight: true,
              colorScheme: widget.isFriendFlow 
                  ? DunnoTextFieldColor.pink 
                  : DunnoTextFieldColor.antiqueWhite,
              onChanged: (value) {
                _giftType = value;
                _updateFilter();
              },
            ),
            const SizedBox(height: 16),

            // Extra Notes Field
            DunnoTextField(
              controller: _extraNotesController,
              label: 'Additional preferences?',
              supportingText: 'Any specific requirements or restrictions',
              keyboardType: TextInputType.text,
              isLight: true,
              colorScheme: widget.isFriendFlow 
                  ? DunnoTextFieldColor.pink 
                  : DunnoTextFieldColor.antiqueWhite,
              maxLines: 3,
              onChanged: (value) {
                _extraNotes = value;
                _updateFilter();
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _updateFilter() {
    final filterSuggestion = FilterSuggestion(
      title: _relation ?? '',
      minBudget: _minBudget,
      maxBudget: _maxBudget,
      category: _giftCategory,
      giftValue: _giftValue,
      giftType: _giftType,
      extraNote: _extraNotes,
    );

    widget.onFilterUpdated?.call(filterSuggestion);
  }

  String _getCategoryDisplayName(GiftCategory category) {
    switch (category) {
      case GiftCategory.tech:
        return 'Technology';
      case GiftCategory.fashion:
        return 'Fashion';
      case GiftCategory.home:
        return 'Home & Garden';
      case GiftCategory.sports:
        return 'Sports & Outdoors';
      case GiftCategory.books:
        return 'Books & Media';
      case GiftCategory.toys:
        return 'Toys & Games';
      case GiftCategory.other:
        return 'Other';
    }
  }

  String _getValueDisplayName(GiftValue value) {
    switch (value) {
      case GiftValue.low:
        return 'Budget-Friendly';
      case GiftValue.medium:
        return 'Mid-Range';
      case GiftValue.high:
        return 'Premium';
    }
  }
}
