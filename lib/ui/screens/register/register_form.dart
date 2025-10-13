import 'package:dunno/constants/constants.dart';
import 'package:dunno/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:dunno/models/app_user_profile.dart';
import 'package:dunno/ui/screens/register/register_button.dart';
import 'package:dunno/ui/widgets/dunno_button.dart';
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
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final RegisterCubit _registerCubit = sl<RegisterCubit>();
  final AuthenticationCubit _authenticationCubit = sl<AuthenticationCubit>();
  final AppUserProfileCubit _appUserProfileCubit = sl<AppUserProfileCubit>();

  bool _passwordVisible = false;

  bool get isPopulated => _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty && _confirmPasswordController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState state) {
    return isPopulated && !state.isInProgress;
  }

  void _onFormSubmitted() async {
    List<String> nameParts = _nameController.text.split(' ');
    String name = nameParts.isNotEmpty ? nameParts.first : '';
    String surname = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
    await _appUserProfileCubit.saveAppUserProfileDetailsToState(
      appUserProfile: AppUserProfile(name: name, surname: surname),
    );

    _registerCubit.registerSubmitted(email: _emailController.text.trim(), password: _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      bloc: _registerCubit,
      listener: (context, state) {
        if (state.isInProgress) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Registering...', style: TextStyle(color: Colors.white)),
                    CircularProgressIndicator(color: Colors.white),
                  ],
                ),
              ),
            );
        }

        if (state.isSuccess) {
          _authenticationCubit.sendVerificationEmail();
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
                      child: Text('Registration Failure\n${state.errorMessage ?? state.message ?? ''}', style: const TextStyle(color: Colors.white)),
                    ),
                    const Icon(Icons.error),
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
                    Text('Password reset email has been sent', style: TextStyle(color: Colors.white)),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Colors.green,
              ),
            );
        }

        if (state is RegisterStateEmailAlreadyExists) {
          _registerCubit.signInFromRegistration(_emailController.text, _passwordController.text);
        }
      },
      child: BlocBuilder<RegisterCubit, RegisterState>(
        bloc: _registerCubit,
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                DunnoTextField(
                  isLight: true,
                  label: 'Name & Surname',
                  controller: _nameController,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                SizedBox(height: 10),
                DunnoTextField(isLight: true, label: 'Email', controller: _emailController, keyboardType: TextInputType.emailAddress, onChanged: (value) => _registerCubit.emailChanged(value)),
                SizedBox(height: 10),
                DunnoTextField(
                  isLight: true,
                  label: 'Password',
                  controller: _passwordController,
                  obscureText: !_passwordVisible,
                  onChanged: (value) => _registerCubit.passwordChanged(value),
                  suffixIcon: IconButton(
                    icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
                SizedBox(height: 10),
                DunnoTextField(
                  isLight: true,
                  label: 'Confirm Password',
                  controller: _confirmPasswordController,
                  obscureText: !_passwordVisible,
                  onChanged: (value) => _registerCubit.confirmPasswordChanged(value),
                  suffixIcon: IconButton(
                    icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
                SizedBox(height: 30),
                RegisterButton(onPressed: isRegisterButtonEnabled(state) ? _onFormSubmitted : () {}),
                DunnoButton(
                  label: 'Back to Login',
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  type: ButtonType.outline,
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
}
