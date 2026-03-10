import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:ui';
import './screens/home.dart';
import './providers/theme_provider.dart';
import './providers/locale_provider.dart';
import './providers/purchase_provider.dart';
import './providers/xp_provider.dart';
import './providers/goal_provider.dart';
import './helpers/notification_helper.dart';
import './helpers/purchase_helper.dart';
import './constants/themes.dart';
import './screens/onboarding_screen.dart';
import 'package:avoid_todo/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:home_widget/home_widget.dart';
import './helpers/app_crash_reporter.dart';
import './helpers/app_firebase.dart';

void main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await AppFirebase.initialize();

      FlutterError.onError = AppCrashReporter.instance.recordFlutterFatalError;
      PlatformDispatcher.instance.onError = (error, stackTrace) {
        AppCrashReporter.instance.recordError(
          error,
          stackTrace,
          reason: 'platform_dispatcher',
          fatal: true,
        );
        return true;
      };

      // Required for iOS widget to share data via App Group
      HomeWidget.setAppGroupId('group.com.roymassaad.avoid_todo');

      await PurchaseHelper.init();
      final purchaseProvider = PurchaseProvider();
      await purchaseProvider.refresh();

      final notificationHelper = NotificationHelper();
      try {
        await notificationHelper.init();
      } catch (error, stackTrace) {
        await AppCrashReporter.instance.recordError(
          error,
          stackTrace,
          reason: 'notification_init',
        );
      }

      final prefs = await SharedPreferences.getInstance();
      final bool hasSeenOnboarding =
          prefs.getBool('hasSeenOnboarding') ?? false;
      final bool notificationsEnabled =
          prefs.getBool('notifications_enabled') ?? true;
      if (notificationsEnabled) {
        try {
          await notificationHelper.scheduleDailyCheckInNotification();
          await notificationHelper.scheduleWeeklyDigest();
        } catch (error, stackTrace) {
          await AppCrashReporter.instance.recordError(
            error,
            stackTrace,
            reason: 'startup_notification_schedule',
          );
        }
      }

      runApp(
        RestartWidget(
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => ThemeProvider()),
              ChangeNotifierProvider(create: (_) => LocaleProvider()),
              ChangeNotifierProvider.value(value: purchaseProvider),
              ChangeNotifierProvider(create: (_) => XpProvider()),
              ChangeNotifierProvider(create: (_) => GoalProvider()),
            ],
            child: MyApp(hasSeenOnboarding: hasSeenOnboarding),
          ),
        ),
      );
    },
    (error, stackTrace) async {
      await AppCrashReporter.instance.recordError(
        error,
        stackTrace,
        reason: 'run_zoned_guarded',
        fatal: true,
      );
    },
  );
}

/// Wraps the entire app so any descendant can trigger a full widget-tree
/// rebuild (soft restart) by calling [RestartWidget.restartApp].
/// Used after a DB restore so all providers reload from the new database.
class RestartWidget extends StatefulWidget {
  final Widget child;
  const RestartWidget({super.key, required this.child});

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?.restartApp();
  }

  @override
  State<RestartWidget> createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key _key = UniqueKey();

  void restartApp() {
    setState(() => _key = UniqueKey());
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(key: _key, child: widget.child);
  }
}

class MyApp extends StatelessWidget {
  final bool hasSeenOnboarding;
  const MyApp({super.key, required this.hasSeenOnboarding});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    return Consumer2<ThemeProvider, LocaleProvider>(
      builder: (context, themeProvider, localeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Avoid Things Todo',
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: themeProvider.themeMode,
          locale: localeProvider.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: hasSeenOnboarding ? const Home() : const OnboardingScreen(),
        );
      },
    );
  }
}
