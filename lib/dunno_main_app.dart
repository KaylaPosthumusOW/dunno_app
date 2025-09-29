import 'package:dunno/core/navigation.dart';
import 'package:flutter/material.dart';

import 'constants/themes.dart';

class DunnoMainApp extends StatelessWidget {
  const DunnoMainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!FocusScope.of(context).hasPrimaryFocus) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: MaterialApp.router(
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
        themeMode: kDefaultThemeMode,
        theme: FrameTheme.lightTheme(true),
        darkTheme: FrameTheme.darkTheme(true),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
            child: child!,
          );
        },
      ),
    );
  }
}
