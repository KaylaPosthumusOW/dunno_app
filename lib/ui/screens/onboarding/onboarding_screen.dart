import 'package:dunno/constants/constants.dart';
import 'package:dunno/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:dunno/models/app_user_profile.dart';
import 'package:dunno/ui/screens/collections/create_collection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final AppUserProfileCubit _appUserProfileCubit = sl<AppUserProfileCubit>();

  void _navigateToCreateCollectionIfFirstTime(BuildContext context, AppUserProfile profile) {
    if (!profile.hasCreatedFirstCollection) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const CreateCollectionScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppUserProfileCubit, AppUserProfileState>(
      bloc: _appUserProfileCubit,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Column(
                children: [
                  // Container(margin: const EdgeInsets.only(top: 20), child: Image.asset('assets/images/onboarding.png', width: 160, height: 160)),
                  SizedBox(height: 20),
                  Text('Welcome to the App', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontWeight: FontWeight.w600, height: 1.2)),
                  SizedBox(height: 10),
                  Text('This is the onboarding screen. Here you can introduce your app to new users.', style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      final updatedProfile = state.mainAppUserProfileState.appUserProfile!.copyWith(
                        hasSeenOnboarding: true,
                      );
                      _appUserProfileCubit.updateProfile(updatedProfile);

                      _navigateToCreateCollectionIfFirstTime(context, updatedProfile);
                    },
                    child: Text('Get Started'),
                  ),
                ],
              ),
            ],
          ),
        );
      }
    );
  }
}
