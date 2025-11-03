import 'package:dunno/ui/widgets/custom_header_bar.dart';
import 'package:flutter/material.dart';

import 'login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomHeaderBar(
            title: 'Welcome Back',
            // centerTitle: true,
          ),
          Expanded(
            child: LoginForm(),
          ),
        ],
      ),
    );
  }
}
