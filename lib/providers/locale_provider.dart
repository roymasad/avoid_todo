import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/app_language.dart';

class LocaleProvider extends ChangeNotifier {
  static const String _localeKey = 'app_locale';

  Locale? _locale;

  Locale? get locale => _locale;
  String? get localeCode => _locale?.languageCode;
  bool get usesSystemLocale => _locale == null;

  LocaleProvider() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString(_localeKey);
    if (localeCode == null) return;
    if (!AppLanguages.isSupportedCode(localeCode)) {
      await prefs.remove(_localeKey);
      return;
    }

    _locale = Locale(localeCode);
    notifyListeners();
  }

  Future<void> setLocale(Locale? locale) async {
    if (_locale?.languageCode == locale?.languageCode) return;

    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.remove(_localeKey);
    } else {
      await prefs.setString(_localeKey, locale.languageCode);
    }
    notifyListeners();
  }
}
