import 'package:dunno/core/dependancy_injection.dart';
import 'package:dunno/dunno_main_app.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print('Warning: Could not load .env file: $e');
    // Continue anyway - the app can still run without .env in development
  }

  await DependencyInjection.init();

  if (!kIsWeb) {
    FlutterError.onError = (FlutterErrorDetails details) async {
      await FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    };
  }

  runApp(DunnoMainApp());
}
