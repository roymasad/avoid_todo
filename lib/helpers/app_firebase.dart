import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import 'app_analytics.dart';
import 'app_crash_reporter.dart';

class AppFirebase {
  AppFirebase._();

  static bool _initialized = false;
  static bool get isInitialized => _initialized;

  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      await Firebase.initializeApp();

      final analytics = FirebaseAnalytics.instance;
      await analytics.setAnalyticsCollectionEnabled(true);
      AppAnalytics.instance.configure(analytics);

      final crashlytics = FirebaseCrashlytics.instance;
      const crashlyticsEnabled = !kDebugMode;
      await crashlytics.setCrashlyticsCollectionEnabled(crashlyticsEnabled);
      if (crashlyticsEnabled) {
        AppCrashReporter.instance.configure(crashlytics);
      } else {
        AppCrashReporter.instance.disable();
      }

      _initialized = true;
    } catch (error, stackTrace) {
      _initialized = false;
      AppAnalytics.instance.disable();
      AppCrashReporter.instance.disable();
      debugPrint('[AppFirebase] initialization failed: $error\n$stackTrace');
    }
  }
}
