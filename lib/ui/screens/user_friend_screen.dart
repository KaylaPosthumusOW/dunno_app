import 'package:dunno/constants/constants.dart';
import 'package:dunno/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:dunno/cubits/connections/connection_cubit.dart';
import 'package:dunno/models/connections.dart';
import 'package:dunno/models/app_user_profile.dart';
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
        final currentUserUid =
            _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile?.uid ?? '';

        return Scaffold(
          appBar: AppBar(title: const Text('Your Friends')),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DunnoSearchField(
                  controller: _searchFriendController,
                  typeSearch: TypeSearch.friends,
                  onChanged: _onSearchChanged,
                ),
                const SizedBox(height: 12),

                // 👇 This Expanded now has bounded height (no SingleChildScrollView above)
                Expanded(
                  child: Builder(
                    builder: (_) {
                      if (state is LoadingConnections) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (connections.isEmpty) {
                        return const Center(
                          child: Text(
                            'No friends yet. Connect with someone to see them here!',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
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
                            final AppUserProfile? friendProfile =
                            (connection.user?.uid == currentUserUid)
                                ? connection.connectedUser
                                : connection.user;

                            return UserProfileCard(
                              userProfile: friendProfile ?? AppUserProfile(),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
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
