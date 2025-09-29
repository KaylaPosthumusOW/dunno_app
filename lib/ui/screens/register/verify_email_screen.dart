import 'package:dunno/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:sp_user_repository/sp_user_repository.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final AuthenticationCubit _authenticationCubit = sl<AuthenticationCubit>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const SizedBox(height: 100),
            Text('Please check your email and verify your account. Check email sent to ${_authenticationCubit.state.mainAuthenticationState.user?.email ?? ''}'),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () => _authenticationCubit.sendVerificationEmail(),
              child: const Text('Resend email'),
            ),
            ElevatedButton(
              onPressed: () => _authenticationCubit.reloadUserCache(),
              child: const Text('Continue'),
            ),
            ElevatedButton(
              onPressed: () => _authenticationCubit.loggedOut(clearPreferences: true),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
