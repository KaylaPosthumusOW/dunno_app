import 'package:dunno/ui/widgets/dunno_button.dart';
import 'package:flutter/material.dart';

class RegisterButton extends StatelessWidget {
  final VoidCallback _onPressed;

  RegisterButton({super.key, VoidCallback? onPressed}) : _onPressed = onPressed!;

  @override
  Widget build(BuildContext context) {
    return DunnoButton(
      type: ButtonType.primary,
      onPressed: _onPressed,
      label: 'Create Your Account',
    );
  }
}
