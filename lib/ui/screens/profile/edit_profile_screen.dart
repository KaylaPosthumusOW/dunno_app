import 'package:dunno/constants/constants.dart';
import 'package:dunno/constants/themes.dart';
import 'package:dunno/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:dunno/ui/widgets/custom_header_bar.dart';
import 'package:dunno/ui/widgets/dunno_button.dart';
import 'package:dunno/ui/widgets/dunno_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final AppUserProfileCubit _appUserProfileCubit = sl<AppUserProfileCubit>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final profile = _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile;
    _nameController.text = profile?.name ?? '';
    _surnameController.text = profile?.surname ?? '';
    _phoneController.text = profile?.phoneNumber ?? '';
    _emailController.text = profile?.email ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomHeaderBar(
            title: 'Edit Profile Details',
            subtitle: 'Update your personal information.',
            onBack: () => Navigator.pop(context),
            backButtonColor: AppColors.yellow,
            iconColor: AppColors.offWhite,
          ),
          Expanded(
            child: BlocListener<AppUserProfileCubit, AppUserProfileState>(
              bloc: _appUserProfileCubit,
              listener: (context, state) {
                if (state is ProfileUpdated) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated successfully!'), backgroundColor: Colors.green));
                } else if (state is ProfileError) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${state.mainAppUserProfileState.errorMessage}'), backgroundColor: Colors.red));
                }
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      DunnoTextField(controller: _nameController, label: 'First Name', isLight: true, colorScheme: DunnoTextFieldColor.yellow,),
                      const SizedBox(height: 16),
                      DunnoTextField(controller: _surnameController, label: 'Last Name', isLight: true, colorScheme: DunnoTextFieldColor.yellow,),
                      const SizedBox(height: 16),
                      DunnoTextField(controller: _phoneController, keyboardType: TextInputType.phone, label: 'Phone Number', isLight: true, colorScheme: DunnoTextFieldColor.yellow,),
                      const SizedBox(height: 16),
                      DunnoTextField(controller: _emailController, keyboardType: TextInputType.phone, label: 'Email Address', isLight: true, readOnly: true, colorScheme: DunnoTextFieldColor.yellow,),
                      const SizedBox(height: 20),
                      BlocBuilder<AppUserProfileCubit, AppUserProfileState>(
                        bloc: _appUserProfileCubit,
                        builder: (context, state) {
                          return Row(
                            children: [
                              Expanded(
                                child: DunnoButton(onPressed: state is ProfileUpdating ? null : _saveProfile, label: 'Save Changes', type: ButtonType.saffron, isLoading: state is ProfileUpdating),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveProfile() {
    final currentProfile = _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile;
    if (currentProfile != null) {
      final updatedProfile = currentProfile.copyWith(name: _nameController.text.trim(), surname: _surnameController.text.trim(), phoneNumber: _phoneController.text.trim());
      _appUserProfileCubit.updateProfile(updatedProfile);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
