import 'package:dunno/constants/themes.dart';
import 'package:flutter/material.dart';

class DunnoDropdownField<T> extends StatelessWidget {
  final String? label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final Function(T?)? onChanged;
  final bool? isDense;
  final String? hintText;
  final Widget? suffixIcon;
  final Color? fillColor;

  final Color? dropDownColor;

  final Color? dropDownTextColor;

  const DunnoDropdownField({super.key, required this.items, this.label, this.value, this.onChanged, this.isDense, this.hintText, this.suffixIcon, this.fillColor, this.dropDownColor, this.dropDownTextColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4, left: 15),
            child: Text(
              label!,
              style: theme.textTheme.labelMedium?.copyWith(
                color: AppColors.black,
              ),
            ),
          ),
        DropdownButtonFormField(
          isDense: isDense ?? false,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            filled: true,
            fillColor: fillColor ?? AppColors.tangerine.withValues(alpha: 0.4),
            hintText: hintText,
            labelStyle: theme.textTheme.labelMedium?.copyWith(color: AppColors.black),
            hintStyle: theme.textTheme.labelMedium?.copyWith(color: AppColors.black),
            errorStyle: theme.textTheme.labelLarge?.copyWith(color: AppColors.cerise),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            counterText: "",
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: AppColors.tangerine.withValues(alpha: 0.4)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: AppColors.antiqueWhite),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: AppColors.antiqueWhite, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: AppColors.cerise, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: AppColors.antiqueWhite, width: 1.5),
            ),
          ),
          isExpanded: true,
          initialValue: value,
          icon: suffixIcon ?? Icon(Icons.keyboard_arrow_down_rounded, size: 30, color: AppColors.black),
          style: theme.textTheme.labelLarge?.copyWith(color: dropDownTextColor ?? Colors.black),
          dropdownColor: dropDownColor ?? Colors.white,
          onChanged: onChanged,
          items: items,
          hint: hintText != null
              ? Text(
            hintText!,
            style: theme.textTheme.labelLarge?.copyWith(
              color: AppColors.black,
            ),
          )
              : null,
        ),
      ],
    );
  }
}
