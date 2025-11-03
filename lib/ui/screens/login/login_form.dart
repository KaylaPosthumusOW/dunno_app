import 'package:dunno/constants/constants.dart';
import 'package:dunno/constants/themes.dart';
import 'package:dunno/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:dunno/ui/screens/login/apple_login_button.dart';
import 'package:dunno/ui/screens/login/create_account_button.dart';
import 'package:dunno/ui/screens/login/google_login_button.dart';
import 'package:dunno/ui/screens/login/login_button.dart';
import 'package:dunno/ui/widgets/dunno_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_user_repository/sp_user_repository.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final LoginCubit _loginCubit = sl<LoginCubit>();
  bool get isPopulated => _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return isPopulated && !state.isInProgress;
  }

  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginCubit, LoginState>(
          bloc: _loginCubit,
          listener: (context, state) async {
            if (state.isFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Expanded(
                          child: Text(state.errorMessage ?? state.message ?? '', style: const TextStyle(color: Colors.white)),
                        ),
                        const Icon(Icons.error),
                      ],
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
            }

            if (state.isInProgress) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Logging In...', style: TextStyle(color: Colors.white)),
                        CircularProgressIndicator(color: Colors.white),
                      ],
                    ),
                    backgroundColor: Colors.black,
                  ),
                );
            }

            if (state.isSuccess) {
              sl<AppUserProfileCubit>().clearState();
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Logged in successfully', style: TextStyle(color: Colors.white)),
                        Icon(Icons.error, color: Colors.white),
                      ],
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
            }
          },
        ),
      ],
      child: BlocBuilder<LoginCubit, LoginState>(
        bloc: _loginCubit,
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                DunnoTextField(
                  label: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => _loginCubit.emailChanged(value), isLight: true,
                  supportingText: 'Email Address',
                  colorScheme: DunnoTextFieldColor.antiqueWhite,
                ),
                SizedBox(height: 10),
                DunnoTextField(
                  label: 'Password',
                  controller: _passwordController,
                  obscureText: !_passwordVisible,
                  supportingText: 'Password',
                  onChanged: (value) => _loginCubit.passwordChanged(value),
                  colorScheme: DunnoTextFieldColor.antiqueWhite,
                  isLight: true,
                  suffixIcon: IconButton(
                    icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off, color: AppColors.black),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      LoginButton(onPressed: isLoginButtonEnabled(state) ? _onFormSubmitted : () => debugPrint('Login button disabled')),
                      SizedBox(height: 10),
                      // Center(
                      //   child: Text('—  Or log in with  —', style: TextStyle(color: AppColors.black)),
                      // ),
                      // SizedBox(height: 20),
                      // Row(mainAxisAlignment: MainAxisAlignment.center, children: [GoogleLoginButton(), SizedBox(width: 15), AppleLoginButton()]),
                      CreateAccountButton(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onFormSubmitted() {
    _loginCubit.loginWithEmailPasswordPressed(email: _emailController.text, password: _passwordController.text);
  }
}
