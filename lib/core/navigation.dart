import 'package:dunno/constants/routes.dart';
import 'package:dunno/ui/screens/dunno_landing_screen.dart';
import 'package:dunno/ui/screens/profile/edit_profile_screen.dart';
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
