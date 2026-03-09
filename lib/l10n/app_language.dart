import 'package:flutter/material.dart';

import 'app_localizations.dart';

class AppLanguage {
  const AppLanguage({
    required this.languageCode,
    required this.flag,
    required this.label,
    this.subtitle,
  });

  final String? languageCode;
  final String flag;
  final String Function(AppLocalizations) label;
  final String Function(AppLocalizations)? subtitle;

  bool get isSystemDefault => languageCode == null;

  Locale? get locale =>
      languageCode == null ? null : Locale(languageCode!);

  bool matchesLocale(Locale? locale) {
    if (languageCode == null) {
      return locale == null;
    }
    return locale?.languageCode == languageCode;
  }
}

class AppLanguages {
  static const List<String> supportedLanguageCodes = <String>[
    'en',
    'fr',
    'es',
    'it',
    'pt',
    'de',
  ];

  static final List<AppLanguage> all = <AppLanguage>[
    AppLanguage(
      languageCode: null,
      flag: '🌐',
      label: (l10n) => l10n.systemDefault,
      subtitle: (l10n) => l10n.followDeviceLanguage,
    ),
    AppLanguage(
      languageCode: 'en',
      flag: '🇺🇸',
      label: (l10n) => l10n.english,
    ),
    AppLanguage(
      languageCode: 'fr',
      flag: '🇫🇷',
      label: (l10n) => l10n.french,
    ),
    AppLanguage(
      languageCode: 'es',
      flag: '🇪🇸',
      label: (l10n) => l10n.spanish,
    ),
    AppLanguage(
      languageCode: 'it',
      flag: '🇮🇹',
      label: (l10n) => l10n.italian,
    ),
    AppLanguage(
      languageCode: 'pt',
      flag: '🇵🇹',
      label: (l10n) => l10n.portuguese,
    ),
    AppLanguage(
      languageCode: 'de',
      flag: '🇩🇪',
      label: (l10n) => l10n.german,
    ),
  ];

  static AppLanguage fromLocale(Locale? locale) {
    return all.firstWhere(
      (language) => language.matchesLocale(locale),
      orElse: () => all.first,
    );
  }

  static bool isSupportedCode(String code) {
    return supportedLanguageCodes.contains(code);
  }
}
