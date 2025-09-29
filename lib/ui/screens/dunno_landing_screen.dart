import 'package:dunno/constants/constants.dart';
import 'package:dunno/ui/screens/dunno_navigation.dart';
import 'package:dunno/ui/screens/login/login_screen.dart';
import 'package:dunno/ui/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_user_repository/sp_user_repository.dart';

class DunnoLandingScreen extends StatefulWidget {
  const DunnoLandingScreen({super.key});

  @override
  State<DunnoLandingScreen> createState() => _DunnoLandingScreenState();
}

class _DunnoLandingScreenState extends State<DunnoLandingScreen> {
  final AuthenticationCubit _authenticationCubit = sl<AuthenticationCubit>()..appStarted(verifyEmail: false);

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      bloc: _authenticationCubit,
      listener: (context, state) {
        if (state is AuthenticationError) {
          _authenticationCubit.reloadUserCache();
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Row(children: [Expanded(child: Text(state.mainAuthenticationState.errorMessage ?? state.mainAuthenticationState.message ?? '', style: const TextStyle(color: Colors.white))), const Icon(Icons.error)]), backgroundColor: Colors.red));
        }
      },
      builder: (context, state) {
        if (state is Uninitialized) {
          return const SplashScreen();
        }

        if (state is Unauthenticated) {
          return const LoginScreen();
        }

        if (state is Authenticated) {
          return const DunnoNavigationScreen();
        }

        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
