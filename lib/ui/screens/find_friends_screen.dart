import 'package:dunno/constants/constants.dart';
import 'package:dunno/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:dunno/cubits/connections/connection_cubit.dart';
import 'package:dunno/models/app_user_profile.dart';
import 'package:dunno/ui/widgets/dunno_search_field.dart';
import 'package:dunno/ui/widgets/user_profile_card.dart';
import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FindFriendsScreen extends StatefulWidget {
  const FindFriendsScreen({super.key});

  @override
  State<FindFriendsScreen> createState() => _FindFriendsScreenState();
}

class _FindFriendsScreenState extends State<FindFriendsScreen> {
  final AppUserProfileCubit _appUserProfileCubit = sl<AppUserProfileCubit>()..loadAllProfiles();
  final ConnectionCubit _connectionCubit = sl<ConnectionCubit>();

  final TextEditingController _searchFriendController = TextEditingController();
  bool _isSearching = false;

  void _enterSearchMode() {
    setState(() => _isSearching = true);
    _appUserProfileCubit.searchUsers('', reset: true);
  }

  void _exitSearchMode() {
    setState(() => _isSearching = false);
    _searchFriendController.clear();
    _appUserProfileCubit.searchUsers('', reset: true);
  }

  void _onSearchChanged(String query) {
    _appUserProfileCubit.searchUsers(query);
  }

  @override
  void initState() {
    super.initState();
    _appUserProfileCubit.searchUsers('', reset: true);
    _connectionCubit.loadAllUserConnections(userUid: _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile?.uid ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppUserProfileCubit, AppUserProfileState>(
      bloc: _appUserProfileCubit,
      builder: (context, state) {
        final users = state.mainAppUserProfileState.searchedUsers ?? [];

        return Scaffold(
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(animation),
                child: child,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: _isSearching ? _buildSearchMode(context, users, state) : _buildDefaultMode(context),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDefaultMode(BuildContext context) {
    return SingleChildScrollView(
      key: const ValueKey('defaultMode'),
      padding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [SvgPicture.asset('assets/svg/find_friends.svg', width: 230, height: 230)]),
                  const Positioned(
                    left: 0,
                    top: 170,
                    child: Text('Find \nFriends', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w600, height: 1.2)),
                  ),
                ],
              ),
              const SizedBox(height: 80),
              Text('Search Friends, Family & Colleagues', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _enterSearchMode,
                child: AbsorbPointer(
                  child: DunnoSearchField(controller: _searchFriendController, typeSearch: TypeSearch.friends, hintText: 'Tap to search...', isPinkVersion: true,),
                ),
              ),
              const SizedBox(height: 130),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchMode(BuildContext context, List<AppUserProfile> users, AppUserProfileState state) {
    return SafeArea(
      key: const ValueKey('searchMode'),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.arrow_back_rounded, size: 22), onPressed: _exitSearchMode),
                Expanded(
                  child: DunnoSearchField(controller: _searchFriendController, typeSearch: TypeSearch.friends, onChanged: _onSearchChanged, isPinkVersion: true,),
                ),
              ],
            ),
          ),

          Expanded(
            child: Builder(
              builder: (context) {
                if (state is SearchingForUsers) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (users.isEmpty) {
                  return const Center(child: Text('No users found'));
                }

                return BlocBuilder<ConnectionCubit, ConnectionState>(
                  bloc: _connectionCubit,
                  builder: (context, state) {
                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: UserProfileCard(userProfile: user),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
