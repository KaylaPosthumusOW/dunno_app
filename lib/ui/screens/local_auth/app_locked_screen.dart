import 'package:dunno/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:sp_user_repository/sp_user_repository.dart';

class AppLockedScreen extends StatefulWidget {
  final Function? sensitiveAction;
  final String? sensitiveActionKey;

  const AppLockedScreen({super.key, this.sensitiveAction, this.sensitiveActionKey});

  @override
  State<AppLockedScreen> createState() => _AppLockedScreenState();
}

class _AppLockedScreenState extends State<AppLockedScreen> {
  final LocalAuthCubit _localAuthCubit = sl<LocalAuthCubit>();

  final TextEditingController _pinEditingController = TextEditingController();

  final PinDecoration _pinDecoration = BoxLooseDecoration(
    strokeColorBuilder: PinListenColorBuilder(Colors.cyan, Colors.green),
    obscureStyle: ObscureStyle(
      isTextObscure: true,
      obscureText: '☺️',
    ),
  );

  Widget _buildPinInputTextFieldExample(LocalAuthState state) {
    return SizedBox(
      height: 64,
      child: PinInputTextField(
        pinLength: 4,
        decoration: _pinDecoration,
        controller: _pinEditingController,
        textInputAction: TextInputAction.go,
        enabled: true,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.characters,
        onSubmit: (pin) {
          debugPrint('submit pin:$pin');
          _localAuthCubit.authenticatePasscode(appPasscode: pin, sensitiveTransaction: state is LocalAuthUnauthenticatedSensitive);
        },
        onChanged: (pin) => debugPrint('onChanged execute. pin:$pin'),
        enableInteractiveSelection: false,
      ),
    );
  }

  Widget _biometricSection(BiometricType biometricType) {
    Widget icon = const SizedBox.shrink();

    switch (biometricType) {
      case BiometricType.face:
        icon = SvgPicture.asset(
          'assets/face_id.svg',
          height: 35,
          width: 35,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.difference),
        );
        break;
      case BiometricType.fingerprint:
        icon = const Icon(Icons.fingerprint, color: Colors.white, size: 35);
        break;
      case BiometricType.iris:
        icon = const Icon(Icons.visibility_outlined, color: Colors.white, size: 35);
        break;
      case BiometricType.strong:
        icon = const Icon(Icons.hdr_strong, color: Colors.white, size: 35);
        break;
      case BiometricType.weak:
        icon = const Icon(Icons.hdr_weak, color: Colors.white, size: 35);
        break;
    }

    return BlocBuilder<LocalAuthCubit, LocalAuthState>(
      bloc: _localAuthCubit,
      builder: (context, state) {
        return Column(
          children: [
            const SizedBox(height: 30),
            SizedBox(
              width: 70,
              height: 70,
              child: ElevatedButton(
                onPressed: () => _localAuthCubit.authenticateSystem('Authenticate using biometrics', state is LocalAuthUnauthenticatedSensitive),
                child: icon,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocalAuthCubit, LocalAuthState>(
      bloc: _localAuthCubit,
      listener: (context, state) async {
        if (state is LocalAuthIncorrect) {
          _pinEditingController.clear();
        }

        if (state is LocalAuthFailed || state is InitializingLocalAuthFailed) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Row(children: [Expanded(child: Text(state.mainLocalAuthState.errorMessage ?? state.mainLocalAuthState.message ?? '', style: const TextStyle(color: Colors.white))), const Icon(Icons.error)]), backgroundColor: Colors.red));
        }

        if (state is LocalAuthAuthenticatedSensitive && Navigator.canPop(context)) {
          Navigator.pop(context);
          if (state.mainLocalAuthState.currentSensitiveActionKey == widget.sensitiveActionKey) {
            widget.sensitiveAction!();
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (state.mainLocalAuthState.localAuthSettings?.passcodeEnabled ?? false) ? _buildPinInputTextFieldExample(state) : const SizedBox.shrink(),
                  (state.mainLocalAuthState.localAuthSettings?.biometricsEnabled ?? false) ? _biometricSection((state.mainLocalAuthState.localAuthSettings?.supportedBiometrics ?? [BiometricType.face])[0]) : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
