import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dunno/constants/constants.dart';
import 'package:dunno/constants/themes.dart';
import 'package:dunno/ui/screens/register/register_button.dart';
import 'package:dunno/ui/widgets/dunno_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_user_repository/sp_user_repository.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  final RegisterCubit _registerCubit = sl<RegisterCubit>();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  bool get isPopulated =>
      _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState state) {
    return isPopulated && !state.isInProgress;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      bloc: _registerCubit,
      listener: (context, state) async {
        if (state.isInProgress) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Registering...', style: TextStyle(color: Colors.white)),
                    CircularProgressIndicator(color: Colors.white)
                  ],
                ),
              ),
            );
        }

        if (state.isSuccess) {
          Navigator.of(context).pop();
        }

        if (state.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Registration Failure\n${state.errorMessage ?? state.message ?? ''}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const Icon(Icons.error, color: Colors.white),
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }

        if (state is RegisterStatePasswordResetSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Password reset email has been sent',
                      style: TextStyle(color: Colors.white),
                    ),
                    Icon(Icons.check_circle, color: Colors.white),
                  ],
                ),
                backgroundColor: Colors.green,
              ),
            );
        }

        if (state is RegisterStateEmailAlreadyExists) {
          _registerCubit.signInFromRegistration(
              _emailController.text, _passwordController.text);
        }
      },
      child: BlocBuilder<RegisterCubit, RegisterState>(
        bloc: _registerCubit,
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              child: ListView(
                children: <Widget>[
                  const SizedBox(height: 60),
                  Text(
                    'Create Your Account!',
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                        ?.copyWith(color: AppColors.black),
                  ),
                  const SizedBox(height: 10),
                  DunnoTextField(
                    label: 'Email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => _registerCubit.emailChanged(value),
                    isLight: true,
                  ),
                  const SizedBox(height: 10),
                  DunnoTextField(
                    label: 'Password',
                    controller: _passwordController,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                      child: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                    ),
                    obscureText: !_passwordVisible,
                    onChanged: (value) => _registerCubit.passwordChanged(value),
                    isLight: true,
                  ),
                  const SizedBox(height: 10),
                  DunnoTextField(
                    label: 'Confirm Password',
                    controller: _confirmPasswordController,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _confirmPasswordVisible = !_confirmPasswordVisible;
                        });
                      },
                      child: Icon(
                        _confirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                    ),
                    obscureText: !_confirmPasswordVisible,
                    onChanged: (value) =>
                        _registerCubit.confirmPasswordChanged(value),
                    isLight: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        RegisterButton(
                          onPressed: isRegisterButtonEnabled(state)
                              ? _onFormSubmitted
                              : () {},
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Already Have an Account?'),
                            TextButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Login',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                  color: AppColors.black,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
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
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onFormSubmitted() {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    _registerCubit.registerSubmitted(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }
}
