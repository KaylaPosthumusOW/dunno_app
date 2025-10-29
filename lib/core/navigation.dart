import 'package:dunno/constants/routes.dart';
import 'package:dunno/ui/screens/collections/collection_detail_screen.dart';
import 'package:dunno/ui/screens/collections/create_collection_screen.dart';
import 'package:dunno/ui/screens/collections/view_all_collections_screen.dart';
import 'package:dunno/ui/screens/dunno_landing_screen.dart';
import 'package:dunno/ui/screens/find_friends_screen.dart';
import 'package:dunno/ui/screens/friend_gift_suggestion/friend_gift_suggestion_management.dart';
import 'package:dunno/ui/screens/friend_gift_suggestion/friend_gift_suggestions_screen.dart';
import 'package:dunno/ui/screens/profile/edit_profile_screen.dart';
import 'package:dunno/ui/screens/profile/friend_profile_screen.dart';
import 'package:dunno/ui/screens/quick_gift_suggestion/gift_suggestion_management.dart';
import 'package:dunno/ui/screens/quick_gift_suggestion/receive_gift_suggestion_screen.dart';
import 'package:dunno/ui/screens/quick_suggestion_screen.dart';
import 'package:dunno/ui/screens/search_friends_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: MAIN_SCREEN,
    navigatorKey: rootNavigatorKey,
    routes: <GoRoute>[
      GoRoute(
        path: MAIN_SCREEN,
        name: MAIN_SCREEN,
        builder: (BuildContext context, GoRouterState state) => DunnoLandingScreen(),
      ),
      GoRoute(
        path: EDIT_PROFILE_SCREEN,
        name: EDIT_PROFILE_SCREEN,
        builder: (BuildContext context, GoRouterState state) => EditProfileScreen(),
      ),
      GoRoute(
        path: COLLECTIONS_SCREEN,
        name: COLLECTIONS_SCREEN,
        builder: (BuildContext context, GoRouterState state) => ViewAllCollectionsScreen(),
      ),
      GoRoute(
        path: CREATE_COLLECTION_SCREEN,
        name: CREATE_COLLECTION_SCREEN,
        builder: (BuildContext context, GoRouterState state) => CreateCollectionScreen(),
      ),
      GoRoute(
        path: SEARCH_FRIENDS_SCREEN,
        name: SEARCH_FRIENDS_SCREEN,
        builder: (BuildContext context, GoRouterState state) => SearchFriendsScreen(),
      ),
      GoRoute(
        path: COLLECTION_DETAIL_SCREEN,
        name: COLLECTION_DETAIL_SCREEN,
        builder: (BuildContext context, GoRouterState state) => CollectionDetailsScreen(),
      ),
      GoRoute(
        path: QUICK_SUGGESTIONS_SCREEN,
        name: QUICK_SUGGESTIONS_SCREEN,
        builder: (BuildContext context, GoRouterState state) => QuickSuggestionScreen(),
      ),
      GoRoute(
        path: FIND_FRIENDS_SCREEN,
        name: FIND_FRIENDS_SCREEN,
        builder: (BuildContext context, GoRouterState state) => FindFriendsScreen(),
      ),
      GoRoute(
        path: FRIEND_PROFILE_SCREEN,
        name: FRIEND_PROFILE_SCREEN,
        builder: (BuildContext context, GoRouterState state) => FriendProfileScreen(),
      ),
      GoRoute(
        path: FRIEND_GIFT_SUGGESTION_SCREEN,
        name: FRIEND_GIFT_SUGGESTION_SCREEN,
        builder: (BuildContext context, GoRouterState state) {
          final extra = state.extra as Map<String, dynamic>?;
          return FriendGiftSuggestionsScreen(
            friendData: extra?['friend'],
            collectionData: extra?['collection'],
            filterData: extra?['filters'],
          );
        },
      ),
      GoRoute(
        path: FRIEND_GIFT_SUGGESTION_MANAGEMENT,
        name: FRIEND_GIFT_SUGGESTION_MANAGEMENT,
        builder: (BuildContext context, GoRouterState state) {
          final extra = state.extra as Map<String, dynamic>?;
          return FriendGiftSuggestionManagement(
            friendData: extra?['friend'],
            collectionData: extra?['collection'],
          );
        },
      ),
      GoRoute(
        path: GIFT_SUGGESTION_MANAGEMENT,
        name: GIFT_SUGGESTION_MANAGEMENT,
        builder: (BuildContext context, GoRouterState state) => GiftSuggestionManagement(),
      ),
      GoRoute(
        path: RECEIVE_GIFT_SUGGESTION_SCREEN,
        name: RECEIVE_GIFT_SUGGESTION_SCREEN,
        builder: (BuildContext context, GoRouterState state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ReceiveGiftSuggestionScreen(
            profile: extra?['profile'],
            filters: extra?['filters'],
          );
        },
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) async {
      return null;
    },
    errorBuilder: (BuildContext context, GoRouterState state) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Route Error'),
        ),
        body: Center(
          child: Text("This path doesn't exist: ${state.uri.toString()}"),
        ),
      );
    },
  );

  static GoRouter get router => _router;
}
