import 'package:flutter/material.dart';

class ForgotPasswordButton extends StatelessWidget {
  final VoidCallback _onPressed;

  ForgotPasswordButton({super.key, VoidCallback? onPressed}) : _onPressed = onPressed!;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: _onPressed,
      child: const Text('Reset password'),
    );
  }
}
