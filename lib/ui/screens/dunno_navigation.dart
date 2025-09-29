import 'package:dunno/constants/constants.dart';
import 'package:dunno/constants/themes.dart';
import 'package:dunno/cubits/general/app_user_profile/app_user_profile_cubit.dart';
import 'package:dunno/ui/screens/find_friends_screen.dart';
import 'package:dunno/ui/screens/home_screen.dart';
import 'package:dunno/ui/screens/profile/profile_screen.dart';
import 'package:dunno/ui/screens/quick_suggestion_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DunnoNavigationScreen extends StatefulWidget {
  const DunnoNavigationScreen({super.key});

  @override
  State<DunnoNavigationScreen> createState() => _DunnoNavigationScreenState();
}

class _DunnoNavigationScreenState extends State<DunnoNavigationScreen> {
  final AppUserProfileCubit _appUserProfileCubit = sl<AppUserProfileCubit>()..loadProfile();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AppUserProfileCubit, AppUserProfileState>(
          bloc: _appUserProfileCubit,
          builder: (context, state) {
            // if (state.mainAppUserProfileState.appUserProfile != null && !state.mainAppUserProfileState.appUserProfile!.hasSeenOnboarding) {
            //   return const OnboardingScreen();
            // }

            return DefaultTabController(
              length: 4,
              child: Scaffold(
                body: const TabBarView(
                  children: [
                    HomeScreen(),
                    FindFriendsScreen(),
                    QuickSuggestionScreen(),
                    ProfileScreen(),
                  ],
                ),
                bottomNavigationBar: Container(
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    border: Border(top: BorderSide(color: AppColors.white, width: 0.5)),
                  ),
                  child: TabBar(
                    labelColor: AppColors.framePurple,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(icon: Icon(Icons.home_rounded), text: 'Home'),
                      Tab(icon: Icon(Icons.image_rounded), text: 'Find Friends'),
                      Tab(icon: Icon(Icons.people_rounded), text: 'Quick Suggestion'),
                      Tab(icon: Icon(Icons.person_rounded), text: 'Profile'),
                    ],
                  ),
                ),
              ),
            );
          }
      ),
    );
  }
}
