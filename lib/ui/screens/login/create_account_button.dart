import 'package:dunno/constants/themes.dart';
import 'package:dunno/ui/screens/register/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CreateAccountButton extends StatelessWidget {
  const CreateAccountButton({super.key});

  _goToRegisterScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Don´t have an account?'),
        ButtonTheme(
          minWidth: 220.0,
          child: TextButton(
            style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
            onPressed: () => _goToRegisterScreen(context),
            child: Text('Register Now', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.framePurple, )),
          ),
        ),
      ],
    );
  }
}
