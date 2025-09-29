import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          'assets/svg/frame_logo_dark.svg',
          height: 32,
        ),
        centerTitle: true,
      ),
      body: LoginForm(),
    );
  }
}
