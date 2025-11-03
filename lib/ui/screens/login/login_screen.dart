import 'package:dunno/constants/themes.dart';
import 'package:dunno/ui/widgets/custom_header_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Column(
                  children: [
                    Container(margin: const EdgeInsets.only(top: 80), child: SvgPicture.asset('assets/svg/login.svg', width: 200, height: 300)),
                    SizedBox(height: 20),
                    Text('Welcome Back!', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontWeight: FontWeight.w600, height: 1.2)),
                    SizedBox(height: 5),
                    Text('Let’s get back to finding the perfect gifts', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[700])),
                    SizedBox(height: 30),
                    const LoginForm(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
