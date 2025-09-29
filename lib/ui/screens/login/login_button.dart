import 'package:dunno/ui/widgets/dunno_button.dart';
import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback _onPressed;

  LoginButton({super.key, VoidCallback? onPressed}) : _onPressed = onPressed!;

  @override
  Widget build(BuildContext context) {
    return DunnoButton(
      type: ButtonType.secondary,
      label: 'Login',
      onPressed: _onPressed,
    );
  }
}
