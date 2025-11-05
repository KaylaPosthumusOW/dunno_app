import 'package:dunno/constants/constants.dart';
import 'package:dunno/constants/themes.dart';
import 'package:dunno/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:dunno/cubits/collections/collection_cubit.dart';
import 'package:dunno/ui/screens/collections/create_collection_screen.dart';
import 'package:dunno/ui/screens/find_friends_screen.dart';
import 'package:dunno/ui/screens/home_screen.dart';
import 'package:dunno/ui/screens/onboarding/onboarding_screen.dart';
import 'package:dunno/ui/screens/profile/profile_screen.dart';
import 'package:dunno/ui/screens/quick_suggestion_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DunnoNavigationScreen extends StatefulWidget {
  const DunnoNavigationScreen({super.key});

  @override
  State<DunnoNavigationScreen> createState() => _DunnoNavigationScreenState();
}

class _DunnoNavigationScreenState extends State<DunnoNavigationScreen> {
  final AppUserProfileCubit _appUserProfileCubit = sl<AppUserProfileCubit>()..loadProfile();
  final CollectionCubit _collectionCubit = sl<CollectionCubit>();

  @override
  void initState() {
    super.initState();
    _collectionCubit.loadAllCollectionsForUser(userUid: _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile?.uid ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AppUserProfileCubit, AppUserProfileState>(
          bloc: _appUserProfileCubit,
          builder: (context, state) {
            final userProfile = state.mainAppUserProfileState.appUserProfile;

            if (userProfile != null && !userProfile.hasSeenOnboarding) {
              return const OnboardingScreen();
            }

            if (userProfile != null && userProfile.hasSeenOnboarding && !userProfile.hasCreatedFirstCollection) {
              return const CreateCollectionScreen(isFirstTimeUser: true);
            }

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
                    color: AppColors.offWhite,
                    border: Border(top: BorderSide(color: AppColors.cerise, width: 0.5)),
                  ),
                  child: TabBar(
                    automaticIndicatorColorAdjustment: false,
                    labelColor: AppColors.cerise,
                    unselectedLabelColor: AppColors.pinkLavender,
                    tabs: [
                      Tab(icon: Icon(Icons.home_rounded), text: 'Home'),
                      Tab(icon: Icon(Icons.image_rounded), text: 'Friends'),
                      Tab(icon: Icon(Icons.people_rounded), text: 'Suggestion'),
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
