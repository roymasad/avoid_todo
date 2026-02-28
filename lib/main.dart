import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import './screens/home.dart';
import './providers/theme_provider.dart';
import './providers/locale_provider.dart';
import './helpers/notification_helper.dart';
import './constants/themes.dart';
import './screens/onboarding_screen.dart';
import 'package:avoid_todo/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final notificationHelper = NotificationHelper();
  try {
    await notificationHelper.init();
  } catch (_) {}

  final prefs = await SharedPreferences.getInstance();
  final bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
  final bool notificationsEnabled =
      prefs.getBool('notifications_enabled') ?? true;
  if (notificationsEnabled) {
    try {
      await notificationHelper.scheduleDailyCheckInNotification();
      await notificationHelper.scheduleWeeklyDigest();
    } catch (_) {}
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: MyApp(hasSeenOnboarding: hasSeenOnboarding),
    ),
  );
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
          supportedLocales: const [
            Locale('en'),
            Locale('fr'),
          ],
          home: hasSeenOnboarding ? const Home() : const OnboardingScreen(),
        );
      },
    );
  }
}
