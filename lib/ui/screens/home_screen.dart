import 'package:dunno/constants/constants.dart';
import 'package:dunno/constants/routes.dart';
import 'package:dunno/constants/themes.dart';
import 'package:dunno/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:dunno/cubits/calender_event_cubit/calender_event_cubit.dart';
import 'package:dunno/models/app_user_profile.dart';
import 'package:dunno/ui/widgets/calender.dart';
import 'package:dunno/ui/widgets/calender_notification_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AppUserProfileCubit _appUserProfileCubit = sl<AppUserProfileCubit>()..loadProfile();
  final CalenderEventCubit _calenderEventCubit = sl<CalenderEventCubit>();

  @override
  void initState() {
    super.initState();
    _appUserProfileCubit.loadProfile();
    _calenderEventCubit.loadAllUserCalenderEvents(userUid: _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile?.uid ?? '');
    _calenderEventCubit.loadUpcomingEventsNotifications(userUid: _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile?.uid ?? '');
  }

  Widget _displayUpComingEvents() {
    return BlocBuilder<CalenderEventCubit, CalenderEventState>(
      bloc: _calenderEventCubit,
      builder: (context, state) {
        if (state is LoadingUpcomingEventsNotifications) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.mainCalenderEventState.upcomingEventsNotifications == null || state.mainCalenderEventState.upcomingEventsNotifications!.isEmpty) {
          return const Center(child: Text('No upcoming events'));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.mainCalenderEventState.upcomingEventsNotifications!.length,
          itemBuilder: (context, index) {
            final event = state.mainCalenderEventState.upcomingEventsNotifications![index];
            return CalenderNotificationCard(upcomingEvent: event);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppUserProfileCubit, AppUserProfileState>(
      bloc: _appUserProfileCubit,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Hello, ${state.mainAppUserProfileState.appUserProfile?.name ?? 'User'}'),
            centerTitle: false,
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: CircleAvatar(
                  backgroundImage: state.mainAppUserProfileState.appUserProfile?.profilePicture != null
                      ? NetworkImage(state.mainAppUserProfileState.appUserProfile!.profilePicture!)
                      : null,
                  child: state.mainAppUserProfileState.appUserProfile?.profilePicture == null
                      ? Icon(Icons.person, color: AppColors.antiqueWhite)
                      : null,
                ),
              )
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _appUserProfileCubit.selectProfile(state.mainAppUserProfileState.appUserProfile ?? AppUserProfile());
                        context.pushNamed(COLLECTIONS_SCREEN);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.yellow,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.folder_copy_outlined, color: AppColors.offWhite),
                              ],
                            ),
                            SizedBox(height: 5),
                            Text('Your \nCollections', style: Theme.of(context).textTheme.displayMedium?.copyWith(color: AppColors.offWhite)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        context.pushNamed(GIFT_BOARDS_SCREEN);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.pinkLavender,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.card_giftcard_rounded, color: AppColors.cerise),
                              ],
                            ),
                            SizedBox(height: 5),
                            Text('Your \nGift Boards', style: Theme.of(context).textTheme.displayMedium?.copyWith(color: AppColors.cerise)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        context.pushNamed(USER_FRIENDS_SCREEN);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.cerise,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.people_outline_rounded, color: AppColors.pinkLavender),
                              ],
                            ),
                            SizedBox(height: 5),
                            Text('Your \nFriends/Family', style: Theme.of(context).textTheme.displayMedium?.copyWith(color: AppColors.pinkLavender)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        DefaultTabController.of(context).animateTo(2);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.cinnabar,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.camera_alt_outlined, color: AppColors.antiqueWhite),
                              ],
                            ),
                            SizedBox(height: 5),
                            Text('Connect \nWith QR', style: Theme.of(context).textTheme.displayMedium?.copyWith(color: AppColors.antiqueWhite)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text('All Your Friends Events', style: Theme.of(context).textTheme.titleMedium),
              BlocBuilder<CalenderEventCubit, CalenderEventState>(
                  bloc: _calenderEventCubit,
                  builder: (context, state) {
                  return Offstage(
                    offstage: state.mainCalenderEventState.upcomingEventsNotifications == null || state.mainCalenderEventState.upcomingEventsNotifications!.isEmpty,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.tangerine,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Upcoming Events', style: Theme.of(context).textTheme.displayMedium?.copyWith(color: AppColors.antiqueWhite)),
                              Icon(Icons.lightbulb_outline_rounded, color: AppColors.antiqueWhite),
                            ],
                          ),
                          _displayUpComingEvents(),
                        ],
                      ),
                    ),
                  );
                }
              ),
              SizedBox(height: 10),
              ModernCalendar()
            ],
          )
        );
      }
    );
  }
}
