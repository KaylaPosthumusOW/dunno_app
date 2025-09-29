import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'register_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: SvgPicture.asset(
          'assets/svg/frame_logo_dark.svg',
          height: 32,
        ),
        centerTitle: true,
      ),
      body: const RegisterForm(),
    );
  }
}
