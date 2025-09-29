import 'package:dunno/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:recase/recase.dart';
import 'package:sp_user_repository/sp_user_repository.dart';

class LocalAuthSettingsScreen extends StatefulWidget {
  const LocalAuthSettingsScreen({super.key});

  @override
  State<LocalAuthSettingsScreen> createState() => _LocalAuthSettingsScreenState();
}

class _LocalAuthSettingsScreenState extends State<LocalAuthSettingsScreen> {
  final LocalAuthCubit _localAuthCubit = sl<LocalAuthCubit>();
  final TextEditingController _passcodeController = TextEditingController();
  final TextEditingController _oldPasscodeController = TextEditingController();
  bool? _pinSaved;

  Widget _switchToggle({required String label, required bool value, required Function onChange}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 18)),
        Switch(
          value: value,
          inactiveTrackColor: Colors.pink.withValues(alpha: 0.5),
          activeTrackColor: Colors.green.withValues(alpha: 0.5),
          inactiveThumbColor: Colors.pink,
          activeColor: Colors.green,
          onChanged: (_) => onChange(),
        ),
      ],
    );
  }

  Widget _passcodeSection() {
    return BlocBuilder<LocalAuthCubit, LocalAuthState>(
      bloc: _localAuthCubit,
      builder: (context, state) {
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _switchToggle(
                  label: 'Enable App Passcode Auth',
                  value: state.mainLocalAuthState.localAuthSettings?.passcodeEnabled ?? false,
                  onChange: (_passcodeController.text.isEmpty && _passcodeController.text.length < 4)
                      ? () {}
                      : () async {
                          if (state.mainLocalAuthState.localAuthSettings?.passcodeEnabled ?? false) {
                            await _localAuthCubit.disableAppPasscode();
                            setState(() => _pinSaved = null);
                          } else {
                            await _localAuthCubit.saveAppPasscode(_passcodeController.text);
                            setState(() => _pinSaved = true);
                          }
                        },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  keyboardAppearance: Brightness.dark,
                  controller: _passcodeController,
                  onChanged: (_) => setState(() => _pinSaved = false),
                  decoration: InputDecoration(
                    icon: const Icon(Icons.pin),
                    labelText: 'Passcode',
                    errorText: (_passcodeController.text.isEmpty || _passcodeController.text.length < 4) ? 'Passcode invalid' : null,
                  ),
                  autocorrect: false,
                ),
                (_pinSaved == null || _pinSaved!)
                    ? const SizedBox.shrink()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(thickness: 1.5, height: 30),
                          const Text('Updating passcode', style: TextStyle(fontSize: 16)),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _oldPasscodeController,
                            onChanged: (_) => setState(() {}),
                            decoration: InputDecoration(
                              icon: const Icon(Icons.pin),
                              labelText: 'Old passcode',
                              errorText: (_oldPasscodeController.text.isEmpty || _oldPasscodeController.text.length < 4) ? 'Passcode invalid' : null,
                            ),
                            autocorrect: false,
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(onPressed: () => _localAuthCubit.updateAppPasscode(_passcodeController.text, _oldPasscodeController.text), child: const Text('Update passcode')),
                        ],
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildSupportedBiometrics(List<BiometricType> biometricTypes) {
    List<Widget> types = [];

    for (BiometricType type in biometricTypes) {
      types.add(
        Expanded(
          child: Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Center(child: Text(type.name.titleCase, style: const TextStyle(fontSize: 16))),
          ),
        ),
      );
    }

    return types;
  }

  Widget _biometricsSection() {
    return BlocBuilder<LocalAuthCubit, LocalAuthState>(
      bloc: _localAuthCubit,
      builder: (context, state) {
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _switchToggle(
                  label: 'Enable Biometrics',
                  value: state.mainLocalAuthState.localAuthSettings?.biometricsEnabled ?? false,
                  onChange: () async {
                    if (state.mainLocalAuthState.localAuthSettings?.biometricsEnabled ?? false) {
                      await _localAuthCubit.disableBiometrics();
                    } else {
                      await _localAuthCubit.enableBiometrics();
                    }
                  },
                ),
                ElevatedButton(onPressed: () => _localAuthCubit.rescanBiometricSettings(), child: const Text('Rescan Biometrics')),
                (state.mainLocalAuthState.localAuthSettings?.supportedBiometrics ?? []).isEmpty
                    ? const SizedBox.shrink()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(thickness: 1.5, height: 30),
                          const Text('Supported Biometrics:', style: TextStyle(fontSize: 16)),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.indigo),
                            padding: const EdgeInsets.all(5),
                            height: 50,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: _buildSupportedBiometrics(state.mainLocalAuthState.localAuthSettings?.supportedBiometrics ?? []),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _passcodeController.text = (_localAuthCubit.state.mainLocalAuthState.localAuthSettings?.passcodeEnabled ?? false) ? '' : '1234';
    _oldPasscodeController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocalAuthCubit, LocalAuthState>(
      bloc: _localAuthCubit,
      listener: (context, state) {
        if (state is LocalAuthFailed || state is InitializingLocalAuthFailed) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Row(children: [Expanded(child: Text(state.mainLocalAuthState.errorMessage ?? state.mainLocalAuthState.message ?? '', style: const TextStyle(color: Colors.white))), const Icon(Icons.warning)]), backgroundColor: Colors.red));
        }

        if (state is UpdatedAppPasscode || state is LocalAuthSettingsUpdated || state is SavedAppPasscode) {
          setState(() => _pinSaved = true);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Row(children: [Expanded(child: Text(state.mainLocalAuthState.message ?? '', style: const TextStyle(color: Colors.white))), const Icon(Icons.info)]), backgroundColor: Colors.green));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Local Auth Settings')),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _switchToggle(
                      label: 'Enable Local Auth',
                      value: state.mainLocalAuthState.localAuthSettings != null,
                      onChange: () async {
                        setState(() => _pinSaved = null);
                        if (state.mainLocalAuthState.localAuthSettings != null) {
                          await _localAuthCubit.disableLocalAuth();
                        } else {
                          await _localAuthCubit.enableLocalAuth();
                        }
                      }),
                  (state.mainLocalAuthState.localAuthSettings != null) ? _passcodeSection() : const SizedBox.shrink(),
                  const SizedBox(height: 20),
                  (state.mainLocalAuthState.localAuthSettings?.biometricsSupported != null) ? _biometricsSection() : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
