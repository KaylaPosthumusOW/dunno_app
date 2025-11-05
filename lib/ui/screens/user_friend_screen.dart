import 'package:dunno/constants/constants.dart';
import 'package:dunno/constants/themes.dart';
import 'package:dunno/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:dunno/cubits/connections/connection_cubit.dart';
import 'package:dunno/models/connections.dart';
import 'package:dunno/models/app_user_profile.dart';
import 'package:dunno/ui/widgets/custom_header_bar.dart';
import 'package:dunno/ui/widgets/dunno_search_field.dart';
import 'package:dunno/ui/widgets/user_profile_card.dart';
import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_bloc/flutter_bloc.dart';

class UserFriendScreen extends StatefulWidget {
  const UserFriendScreen({super.key});

  @override
  State<UserFriendScreen> createState() => _UserFriendScreenState();
}

class _UserFriendScreenState extends State<UserFriendScreen> {
  final AppUserProfileCubit _appUserProfileCubit = sl<AppUserProfileCubit>();
  final ConnectionCubit _connectionCubit = sl<ConnectionCubit>();

  final TextEditingController _searchFriendController = TextEditingController();

  void _onSearchChanged(String query) {
    _appUserProfileCubit.searchUsers(query);
  }

  @override
  void initState() {
    super.initState();
    _connectionCubit.loadAllUserConnections(userUid: _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile?.uid ?? '');
  }

  Future<void> _refresh() async {
    await _connectionCubit.loadAllUserConnections(userUid: _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile?.uid ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectionCubit, ConnectionState>(
      bloc: _connectionCubit,
      builder: (context, state) {
        final connections = state.mainConnectionState.allUserConnections ?? [];
        final currentUserUid = _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile?.uid ?? '';

        return Scaffold(
          body: Column(
            children: [
              CustomHeaderBar(
                title: 'Your Friends',
                subtitle: 'See all the friends you’ve connected with and make their next gift extra special.',
                onBack: () => Navigator.pop(context),
                backButtonColor: AppColors.cerise,
                iconColor: AppColors.offWhite,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DunnoSearchField(controller: _searchFriendController, typeSearch: TypeSearch.friends, onChanged: _onSearchChanged),
                      Expanded(
                        child: Builder(
                          builder: (_) {
                            if (state is LoadingConnections) {
                              return const Center(child: CircularProgressIndicator());
                            }

                            if (connections.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 40),
                                child: Column(
                                  children: [
                                    const Icon(Icons.people_alt_outlined, size: 80, color: Colors.grey),
                                    const SizedBox(height: 12),
                                    Text(_searchFriendController.text.isNotEmpty ? 'No friends found' : 'No friends yet', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 6),
                                    Text(
                                      _searchFriendController.text.isNotEmpty ? 'Try adjusting your search to find friends.' : 'Connect with friends to see them here.',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              );
                            }

                            return RefreshIndicator(
                              onRefresh: _refresh,
                              child: ListView.separated(
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: connections.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 10),
                                itemBuilder: (context, index) {
                                  final Connection connection = connections[index];

                                  // show "the other person" in the connection
                                  final AppUserProfile? friendProfile = (connection.user?.uid == currentUserUid) ? connection.connectedUser : connection.user;

                                  return UserProfileCard(userProfile: friendProfile ?? AppUserProfile());
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchFriendController.dispose();
    super.dispose();
  }
}
