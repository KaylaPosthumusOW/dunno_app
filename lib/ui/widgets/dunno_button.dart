import 'package:dunno/constants/themes.dart';
import 'package:flutter/material.dart';

enum ButtonType { primary, secondary, outline }

class DunnoButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String? label;
  final bool isLoading;
  final bool isDisabled;
  final Widget? loadingIndicator;
  final Icon? icon;
  final ButtonType type;
  final Color? textColor;
  final Color? outlineColor;
  final VoidCallback? onDisabledPress;
  final Color? buttonColor;

  const DunnoButton({
    super.key,
    this.onPressed,
    this.label,
    this.isLoading = false,
    this.isDisabled = false,
    this.loadingIndicator,
    this.icon,
    required this.type,
    this.textColor,
    this.outlineColor,
    this.onDisabledPress,
    this.buttonColor,
  });

  @override
  State<DunnoButton> createState() => _DunnoButtonState();
}

class _DunnoButtonState extends State<DunnoButton> {
  Widget _buildLoadingIndicator() {
    return SizedBox(width: 18, height: 18, child: Center(child: widget.loadingIndicator ?? const CircularProgressIndicator(strokeWidth: 2)));
  }

  Widget _buildLabel(BuildContext context) {
    return Text(
      widget.label ?? '',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  ButtonStyle _getButtonStyle(bool isDisabled) {
    switch (widget.type) {
      case ButtonType.primary:
        return FilledButton.styleFrom(backgroundColor: isDisabled ? AppColors.cerise.withValues(alpha: 0.4) : widget.buttonColor ?? AppColors.cerise, foregroundColor: AppColors.pinkLavender, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)));
      case ButtonType.secondary:
        return FilledButton.styleFrom(backgroundColor: isDisabled ? AppColors.cinnabar.withValues(alpha: 0.4) : widget.buttonColor ?? AppColors.cinnabar, foregroundColor: AppColors.antiqueWhite, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)));
      case ButtonType.outline:
        return OutlinedButton.styleFrom(backgroundColor: Colors.transparent, side: BorderSide(color: isDisabled ? AppColors.cerise : widget.outlineColor ?? AppColors.cerise), foregroundColor: isDisabled ? AppColors.cerise : AppColors.cerise, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)));

    }
  }

  Widget _buildButton(Widget? icon, Widget label, VoidCallback? onPressed, ButtonStyle style) {
    switch (widget.type) {
      case ButtonType.primary:
        return FilledButton.icon(onPressed: onPressed, icon: icon ?? const SizedBox.shrink(), label: label, style: style);
      case ButtonType.secondary:
        return FilledButton.icon(onPressed: onPressed, icon: icon ?? const SizedBox.shrink(), label: label, style: style);
      case ButtonType.outline:
        return OutlinedButton.icon(onPressed: onPressed, icon: icon ?? const SizedBox.shrink(), label: label, style: style);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool effectiveIsDisabled = widget.isDisabled || widget.isLoading;
    final buttonStyle = _getButtonStyle(effectiveIsDisabled);

    return SizedBox(
      height: 50,
      child: _buildButton(
        widget.isLoading ? _buildLoadingIndicator() : widget.icon,
        widget.isLoading ? const SizedBox.shrink() : _buildLabel(context),
        effectiveIsDisabled
            ? () {
          widget.onDisabledPress != null ? widget.onDisabledPress!() : () {};
        }
            : widget.onPressed,
        buttonStyle,
      ),
    );
  }
}
