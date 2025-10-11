import 'package:dunno/constants/constants.dart';
import 'package:dunno/constants/themes.dart';
import 'package:dunno/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:dunno/ui/widgets/calender.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AppUserProfileCubit _appUserProfileCubit = sl<AppUserProfileCubit>();

  @override
  void initState() {
    super.initState();
    _appUserProfileCubit.loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {  },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              Expanded(
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
                          Icon(Icons.folder_copy_outlined, color: AppColors.antiqueWhite),
                        ],
                      ),
                      SizedBox(height: 5),
                      Text('Your \nCollections', style: Theme.of(context).textTheme.displayMedium?.copyWith(color: AppColors.antiqueWhite)),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
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
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.lightbulb_outline_rounded, color: AppColors.antiqueWhite),
                        ],
                      ),
                      SizedBox(height: 5),
                      Text('Quick \nSuggestions', style: Theme.of(context).textTheme.displayMedium?.copyWith(color: AppColors.antiqueWhite)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
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
                    Icon(Icons.lightbulb_outline_rounded, color: AppColors.pinkLavender),
                  ],
                ),
                Text('Find \nFriends/Family', style: Theme.of(context).textTheme.displayMedium?.copyWith(color: AppColors.pinkLavender)),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text('All Your Friends Events', style: Theme.of(context).textTheme.titleMedium),
          Container(
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
                    Text('Upcoming Events', style: Theme.of(context).textTheme.displayMedium?.copyWith(color: AppColors.cinnabar)),
                    Icon(Icons.lightbulb_outline_rounded, color: AppColors.cinnabar),
                  ],
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
          SizedBox(height: 10),
          ModernCalendar()
        ],
      )
    );
  }
}
