import 'package:dunno/core/dependancy_injection.dart';
import 'package:dunno/dunno_main_app.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DependencyInjection.init();

  if (!kIsWeb) {
    FlutterError.onError = (FlutterErrorDetails details) async {
      await FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    };
  }

  runApp(DunnoMainApp());
}
