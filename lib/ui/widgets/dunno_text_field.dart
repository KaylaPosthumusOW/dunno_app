import 'package:dunno/constants/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum DunnoTextFieldColor {
  pink,
  antiqueWhite,
}

class DunnoTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final String? supportingText;
  final bool? enabled;
  final bool? isDense;
  final String? errorText;
  final bool obscureText;
  final bool isLoading;
  final IconData? leadingIcon;
  final Function? onFieldSubmitted;
  final Function? onChanged;
  final Function? onCleared;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final bool? autofocus;
  final int? maxLines;
  final FocusNode? focusNode;
  final bool? expands;
  final int? maxLength;
  final Widget? suffixIcon;
  final bool? applyToAll;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final bool isLight;

  final DunnoTextFieldColor colorScheme;

  const DunnoTextField({
    super.key,
    required this.controller,
    this.label,
    this.supportingText,
    this.enabled,
    this.isDense,
    this.errorText,
    this.onFieldSubmitted,
    this.onChanged,
    this.onCleared,
    this.obscureText = false,
    this.isLoading = false,
    this.leadingIcon,
    this.keyboardType,
    this.textInputAction = TextInputAction.done,
    this.autofocus,
    this.maxLines,
    this.focusNode,
    this.expands,
    this.maxLength,
    this.suffixIcon,
    this.applyToAll,
    this.inputFormatters,
    this.readOnly = false,
    this.isLight = false,
    this.colorScheme = DunnoTextFieldColor.pink,
  });

  @override
  DunnoTextFieldState createState() => DunnoTextFieldState();
}

class DunnoTextFieldState extends State<DunnoTextField> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isErrorState = widget.errorText != null && widget.errorText!.isNotEmpty;

    final ColorSchemeData colors = _getColorScheme(widget.colorScheme, widget.isLight);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null && widget.label!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 4, left: 15),
            child: Text(
              widget.label!,
              style: theme.textTheme.labelMedium?.copyWith(
                color: isErrorState ? AppColors.errorRed : colors.textColor,
              ),
            ),
          ),
        TextField(
          inputFormatters: widget.inputFormatters ?? [],
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          autofocus: widget.autofocus ?? false,
          controller: widget.controller,
          focusNode: widget.focusNode,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType ?? TextInputType.text,
          textInputAction: widget.textInputAction,
          maxLines: widget.keyboardType == TextInputType.multiline ? null : widget.maxLines ?? 1,
          maxLength: widget.maxLength,
          autocorrect: false,
          onSubmitted: widget.onFieldSubmitted != null
              ? (value) => widget.onFieldSubmitted!(value)
              : null,
          onChanged: widget.onChanged != null
              ? (value) => widget.onChanged!(value)
              : null,
          style: theme.textTheme.labelLarge?.copyWith(color: colors.textColor),
          decoration: InputDecoration(
            isDense: widget.isDense,
            filled: true,
            fillColor: colors.fillColor,
            prefixIcon: widget.leadingIcon != null
                ? Icon(widget.leadingIcon, color: colors.iconColor, size: 20)
                : null,
            suffixIcon: !widget.readOnly &&
                widget.controller.text.isNotEmpty &&
                widget.suffixIcon == null
                ? GestureDetector(
              onTap: () {
                widget.controller.clear();
                widget.focusNode?.requestFocus();
                widget.onCleared?.call();
              },
              child: Icon(Icons.clear, color: colors.iconColor, size: 16),
            )
                : widget.suffixIcon,
            hintText: widget.supportingText,
            hintStyle: theme.textTheme.labelLarge?.copyWith(
              color: isErrorState ? AppColors.errorRed : colors.textColor.withValues(alpha: 0.7),
            ),
            errorText: widget.errorText?.isNotEmpty == true ? widget.errorText : null,
            errorStyle: theme.textTheme.labelLarge?.copyWith(color: AppColors.errorRed),
            counterText: "",
            floatingLabelBehavior: FloatingLabelBehavior.never,
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: colors.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: colors.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: colors.focusedColor, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: AppColors.errorRed, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: AppColors.errorRed, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  ColorSchemeData _getColorScheme(DunnoTextFieldColor scheme, bool isLight) {
    switch (scheme) {
      case DunnoTextFieldColor.pink:
        return ColorSchemeData(
          textColor: isLight ? AppColors.black : AppColors.offWhite,
          borderColor: AppColors.pinkLavender.withValues(alpha: 0.6),
          iconColor: AppColors.cerise,
          fillColor: isLight
              ? AppColors.pinkLavender.withValues(alpha: 0.6)
              : AppColors.pinkLavender,
          focusedColor: AppColors.pinkLavender,
        );
      case DunnoTextFieldColor.antiqueWhite:
        return ColorSchemeData(
          textColor: isLight ? AppColors.black : AppColors.offWhite,
          borderColor: AppColors.antiqueWhite.withValues(alpha: 0.6),
          iconColor: AppColors.antiqueWhite,
          fillColor: isLight
              ? AppColors.antiqueWhite.withValues(alpha: 0.6)
              : AppColors.antiqueWhite,
          focusedColor: AppColors.antiqueWhite,
        );
    }
  }
}

/// Helper class to hold all color info for a theme scheme
class ColorSchemeData {
  final Color textColor;
  final Color borderColor;
  final Color iconColor;
  final Color fillColor;
  final Color focusedColor;

  ColorSchemeData({
    required this.textColor,
    required this.borderColor,
    required this.iconColor,
    required this.fillColor,
    required this.focusedColor,
  });
}
