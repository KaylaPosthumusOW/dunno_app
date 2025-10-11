import 'package:dunno/constants/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  const DunnoTextField({super.key, required this.controller, this.label, this.supportingText, this.enabled, this.isDense, this.errorText, this.onFieldSubmitted, this.onChanged, this.onCleared, this.obscureText = false, this.isLoading = false, this.leadingIcon, this.keyboardType, this.textInputAction = TextInputAction.done, this.autofocus, this.maxLines, this.focusNode, this.expands, this.maxLength, this.suffixIcon, this.applyToAll, this.inputFormatters, this.readOnly = false, this.isLight = false});

  @override
  DunnoTextFieldState createState() => DunnoTextFieldState();
}

class DunnoTextFieldState extends State<DunnoTextField> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isErrorState = widget.errorText != null && widget.errorText!.isNotEmpty;

    final textColor = widget.isLight ? AppColors.black : AppColors.offWhite;
    final borderColor = widget.isLight ? AppColors.pinkLavender.withValues(alpha: 0.6) : AppColors.offWhite;
    final iconColor = widget.isLight ? AppColors.cerise : AppColors.offWhite;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4, left: 15),
          child: Text(widget.label ?? '', style: theme.textTheme.labelMedium?.copyWith(color: isErrorState ? AppColors.black : textColor)),
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
              ? (value) {
            widget.onFieldSubmitted!(value);
          }
              : null,
          onChanged: widget.onChanged != null
              ? (value) {
            widget.onChanged!(value);
          }
              : null,
          style: theme.textTheme.labelLarge?.copyWith(color: textColor),
          decoration: InputDecoration(
            isDense: widget.isDense,
            filled: true,
            fillColor: widget.isLight ? AppColors.pinkLavender.withValues(alpha: 0.6) : AppColors.pinkLavender,
            prefixIcon: widget.leadingIcon != null ? Icon(widget.leadingIcon, color: iconColor, size: 20) : null,
            suffixIcon: !widget.readOnly && widget.controller.text.isNotEmpty && widget.suffixIcon == null
                ? GestureDetector(
              onTap: () {
                widget.controller.clear();
                widget.focusNode?.requestFocus();
                widget.onCleared != null ? widget.onCleared!() : null;
              },
              child: Icon(Icons.clear, color: iconColor, size: 16),
            )
                : widget.suffixIcon,
            labelText: widget.label,
            hintText: widget.supportingText,
            labelStyle: theme.textTheme.labelMedium?.copyWith(color: isErrorState ? AppColors.errorRed : textColor.withValues(alpha: 0.7)),
            hintStyle: theme.textTheme.labelLarge?.copyWith(color: isErrorState ? AppColors.errorRed : textColor),
            errorText: widget.errorText != '' ? widget.errorText : null,
            errorStyle: theme.textTheme.labelLarge?.copyWith(color: AppColors.errorRed),
            counterText: "",
            floatingLabelBehavior: FloatingLabelBehavior.never,
            disabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(30)), borderSide: BorderSide(color: borderColor)),
            enabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(30)), borderSide: BorderSide(color: borderColor)),
            focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(30)), borderSide: BorderSide(color: AppColors.pinkLavender, width: 1.5)),
            errorBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(30)), borderSide: BorderSide(color: AppColors.errorRed, width: 1.5)),
            focusedErrorBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(30)), borderSide: BorderSide(color: AppColors.errorRed, width: 1.5)),
          ),
        ),
      ],
    );
  }
}
