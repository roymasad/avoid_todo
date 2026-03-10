import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:avoid_todo/l10n/app_localizations.dart';
import 'package:avoid_todo/providers/locale_provider.dart';
import 'package:avoid_todo/widgets/language_settings_tile.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpLanguageTile(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => LocaleProvider(),
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: LanguageSettingsTile(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows a compact language row and opens the picker sheet',
      (WidgetTester tester) async {
    await pumpLanguageTile(tester);

    expect(find.byKey(const Key('drawer_language_tile')), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('System Default'), findsOneWidget);
    expect(find.byType(RadioListTile<Locale>), findsNothing);

    await tester.tap(find.byKey(const Key('drawer_language_tile')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('language_picker_sheet')), findsOneWidget);
    expect(find.byKey(const Key('language_option_system')), findsOneWidget);
    expect(find.byKey(const Key('language_option_en')), findsOneWidget);
    expect(find.byKey(const Key('language_option_fr')), findsOneWidget);
    expect(find.byKey(const Key('language_option_es')), findsOneWidget);
    expect(find.byKey(const Key('language_option_it')), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(const Key('language_option_pt')),
      100,
    );
    expect(find.byKey(const Key('language_option_pt')), findsOneWidget);
    expect(find.byKey(const Key('language_option_de')), findsOneWidget);

    expect(
      tester.getTopLeft(find.byKey(const Key('language_option_system'))).dy,
      lessThan(
          tester.getTopLeft(find.byKey(const Key('language_option_en'))).dy),
    );
    expect(
      tester.getTopLeft(find.byKey(const Key('language_option_en'))).dy,
      lessThan(
          tester.getTopLeft(find.byKey(const Key('language_option_fr'))).dy),
    );
    expect(
      tester.getTopLeft(find.byKey(const Key('language_option_fr'))).dy,
      lessThan(
          tester.getTopLeft(find.byKey(const Key('language_option_es'))).dy),
    );
  });

  testWidgets('updates the current selection and can return to system default',
      (WidgetTester tester) async {
    await pumpLanguageTile(tester);

    await tester.tap(find.byKey(const Key('drawer_language_tile')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('language_option_fr')));
    await tester.pumpAndSettle();

    expect(find.text('Français'), findsOneWidget);

    await tester.tap(find.byKey(const Key('drawer_language_tile')));
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byKey(const Key('language_option_fr')),
        matching: find.byIcon(Icons.check),
      ),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('language_option_system')));
    await tester.pumpAndSettle();

    expect(find.text('System Default'), findsOneWidget);
  });
}
