import 'package:dunno/constants/themes.dart';
import 'package:dunno/ui/widgets/dunno_button.dart';
import 'package:flutter/material.dart';

class DunnoAlertDialog extends StatefulWidget {
  final String title;
  final String content;
  final Widget? widgetContent;
  final Function? action;
  final String? actionTitle;
  final Function? cancelAction;
  final String? cancelText;
  final bool onlyShowOneButton;
  final String? oneButtonText;

  const DunnoAlertDialog({super.key, this.widgetContent, this.cancelText, required this.title, this.action, this.cancelAction, required this.content, this.onlyShowOneButton = false, this.actionTitle, this.oneButtonText});

  @override
  DunnoAlertDialogState createState() => DunnoAlertDialogState();
}

class DunnoAlertDialogState extends State<DunnoAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
      title: Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
      content: widget.widgetContent ?? Text(widget.content, style: Theme.of(context).textTheme.bodyLarge),
      actions: [
        widget.onlyShowOneButton
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: DunnoButton(
                    onPressed: () => widget.action != null ? widget.action!() : Navigator.pop(context),
                    label: widget.oneButtonText ?? '',
                    type: ButtonType.primary,
                  ),
                ),
              )
            : Row(
                children: [
                  Expanded(
                    child: DunnoButton(
                      onPressed: () => widget.cancelAction != null ? widget.cancelAction!() : Navigator.pop(context),
                      label: widget.cancelText ?? 'Cancel',
                      type: ButtonType.outline,
                      textColor: AppColors.cerise,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DunnoButton(
                      onPressed: () => widget.action!(),
                      label: widget.actionTitle ?? 'Yes',
                      type: ButtonType.primary,
                    ),
                  ),
                ],
              ),
        const SizedBox(height: 8),
      ],
    );
  }
}
