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
        // title: SvgPicture.asset(
        //   'assets/svg/frame_logo_dark.svg',
        //   height: 32,
        // ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Column(
            children: [
              Container(margin: const EdgeInsets.only(top: 20), child: SvgPicture.asset('assets/svg/celebration.svg', width: 160, height: 160)),
              SizedBox(height: 20),
              Text('Create Your Account', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontWeight: FontWeight.w600, height: 1.2)),
              SizedBox(height: 10),
              const RegisterForm(),
            ],
          ),
        ],
      ),
    );
  }
}
