import 'package:dunno/constants/constants.dart';
import 'package:dunno/constants/routes.dart';
import 'package:dunno/constants/themes.dart';
import 'package:dunno/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:dunno/cubits/calender_event_cubit/calender_event_cubit.dart';
import 'package:dunno/models/app_user_profile.dart';
import 'package:dunno/ui/screens/scanner_screen.dart';
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

  Widget _displayUpComingEvents(CalenderEventState state) {
    final upcomingEvents = state.mainCalenderEventState.upcomingEventsNotifications ?? [];

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: upcomingEvents.length,
      separatorBuilder: (context, index) => SizedBox(height: 10),
      itemBuilder: (context, index) {
        final event = upcomingEvents[index];
        return CalenderNotificationCard(upcomingEvent: event);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppUserProfileCubit, AppUserProfileState>(
      bloc: _appUserProfileCubit,
      listener: (context, state) {
        if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading profile: ${state.mainAppUserProfileState.errorMessage}'), backgroundColor: AppColors.cinnabar));
        }

        if (state is ProfileInitialLoaded) {
          _calenderEventCubit.loadAllUserCalenderEvents(userUid: state.mainAppUserProfileState.appUserProfile?.uid ?? '');
          _calenderEventCubit.loadUpcomingEventsNotifications(userUid: state.mainAppUserProfileState.appUserProfile?.uid ?? '');
        }
      },
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Hello, ${state.mainAppUserProfileState.appUserProfile?.name ?? 'User'}', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
            centerTitle: false,
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: CircleAvatar(
                  backgroundColor: Colors.grey.shade400,
                  backgroundImage: state.mainAppUserProfileState.appUserProfile?.profilePicture != null ? NetworkImage(state.mainAppUserProfileState.appUserProfile!.profilePicture!) : null,
                  child: state.mainAppUserProfileState.appUserProfile?.profilePicture == null ? Icon(Icons.person, color: AppColors.offWhite) : null,
                ),
              ),
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
                        decoration: BoxDecoration(color: AppColors.yellow, borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [Icon(Icons.folder_copy_outlined, color: AppColors.offWhite)],
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
                        decoration: BoxDecoration(color: AppColors.pinkLavender, borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [Icon(Icons.card_giftcard_rounded, color: AppColors.cerise)],
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
                        decoration: BoxDecoration(color: AppColors.cerise, borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [Icon(Icons.people_outline_rounded, color: AppColors.pinkLavender)],
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
                      onTap: () async {
                        final scanned = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const QrScannerScreen()));

                        if (!context.mounted) return;

                        if (scanned is String && scanned.isNotEmpty) {
                          String? uid;
                          final uri = Uri.tryParse(scanned);
                          if (uri != null && uri.hasQuery) {
                            uid = uri.queryParameters['uid'];
                          }
                          uid ??= scanned;

                          if (uid.isNotEmpty) {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => const Center(child: CircularProgressIndicator()),
                            );

                            try {
                              await _appUserProfileCubit.selectProfileById(uid);

                              if (!context.mounted) return;
                              Navigator.of(context).pop();
                              context.pushNamed(FRIEND_PROFILE_SCREEN);
                            } catch (e) {
                              if (!context.mounted) return;
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load profile: $e')));
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid QR code')));
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: AppColors.cinnabar, borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [Icon(Icons.camera_alt_outlined, color: AppColors.antiqueWhite)],
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
                  final count = state.mainCalenderEventState.upcomingEventsNotifications?.length ?? 0;

                  final message = count == 0 ? 'You have no upcoming events' : 'You have $count upcoming ${count == 1 ? 'event' : 'events'}!';
                  return Offstage(
                    offstage: state.mainCalenderEventState.upcomingEventsNotifications == null || state.mainCalenderEventState.upcomingEventsNotifications!.isEmpty,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text(message, style: Theme.of(context).textTheme.bodyMedium)],
                        ),
                        _displayUpComingEvents(state),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 10),
              ModernCalendar(),
            ],
          ),
        );
      },
    );
  }
}
