import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:avoid_todo/providers/locale_provider.dart';

Future<void> _settleProviderLoad() async {
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocaleProvider', () {
    test('uses system locale when no saved preference exists', () async {
      SharedPreferences.setMockInitialValues({});

      final provider = LocaleProvider();
      await _settleProviderLoad();

      expect(provider.locale, isNull);
      expect(provider.usesSystemLocale, isTrue);
    });

    test('loads a supported saved locale override', () async {
      SharedPreferences.setMockInitialValues({'app_locale': 'fr'});

      final provider = LocaleProvider();
      await _settleProviderLoad();

      expect(provider.locale, const Locale('fr'));
      expect(provider.localeCode, 'fr');
    });

    test('ignores unsupported saved locale codes', () async {
      SharedPreferences.setMockInitialValues({'app_locale': 'xx'});

      final provider = LocaleProvider();
      await _settleProviderLoad();

      final prefs = await SharedPreferences.getInstance();

      expect(provider.locale, isNull);
      expect(provider.usesSystemLocale, isTrue);
      expect(prefs.getString('app_locale'), isNull);
    });

    test('persists explicit locale choices and clears them for system default',
        () async {
      SharedPreferences.setMockInitialValues({});

      final provider = LocaleProvider();
      await _settleProviderLoad();
      final prefs = await SharedPreferences.getInstance();

      await provider.setLocale(const Locale('es'));
      expect(provider.locale, const Locale('es'));
      expect(prefs.getString('app_locale'), 'es');

      await provider.setLocale(null);
      expect(provider.locale, isNull);
      expect(provider.usesSystemLocale, isTrue);
      expect(prefs.getString('app_locale'), isNull);
    });
  });
}
