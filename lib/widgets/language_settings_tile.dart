import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/app_analytics.dart';
import '../l10n/app_language.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';

class LanguageSettingsTile extends StatelessWidget {
  const LanguageSettingsTile({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final l10n = AppLocalizations.of(context)!;
    final selectedLanguage = AppLanguages.fromLocale(localeProvider.locale);

    return ListTile(
      key: const Key('drawer_language_tile'),
      leading: const Icon(Icons.language),
      title: Text(l10n.language),
      subtitle: Text(selectedLanguage.label(l10n)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showLanguagePicker(context),
    );
  }

  Future<void> _showLanguagePicker(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Consumer<LocaleProvider>(
            builder: (context, localeProvider, _) {
              return Column(
                key: const Key('language_picker_sheet'),
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        l10n.language,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.75,
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        for (final language in AppLanguages.all)
                          ListTile(
                            key: Key(
                              'language_option_${language.languageCode ?? 'system'}',
                            ),
                            leading: Text(
                              language.flag,
                              style: const TextStyle(fontSize: 22),
                            ),
                            title: Text(language.label(l10n)),
                            subtitle: language.subtitle == null
                                ? null
                                : Text(language.subtitle!(l10n)),
                            trailing: language
                                    .matchesLocale(localeProvider.locale)
                                ? Icon(
                                    Icons.check,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  )
                                : null,
                            onTap: () async {
                              await localeProvider.setLocale(language.locale);
                              await AppAnalytics.instance.trackEvent(
                                'language_changed',
                                parameters: {
                                  'source_screen': 'home_tab',
                                  'result': 'success',
                                  'language': language.languageCode ?? 'system',
                                },
                              );
                              if (!sheetContext.mounted || !context.mounted) {
                                return;
                              }
                              Navigator.of(sheetContext).pop();
                              final navigator = Navigator.of(context);
                              if (navigator.canPop()) {
                                navigator.pop();
                              }
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
