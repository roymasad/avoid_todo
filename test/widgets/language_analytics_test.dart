import 'package:avoid_todo/helpers/app_analytics.dart';
import 'package:avoid_todo/l10n/app_localizations.dart';
import 'package:avoid_todo/providers/locale_provider.dart';
import 'package:avoid_todo/widgets/language_settings_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _CapturedEvent {
  const _CapturedEvent(this.name, this.parameters);

  final String name;
  final Map<String, Object> parameters;
}

class _FakeAnalyticsSink implements AnalyticsSink {
  final List<_CapturedEvent> events = [];

  @override
  Future<void> logEvent(String name, Map<String, Object> parameters) async {
    events.add(_CapturedEvent(name, Map<String, Object>.from(parameters)));
  }

  @override
  Future<void> logScreenView(String screenName, {String? screenClass}) async {}
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() {
    AppAnalytics.instance.setSinkForTesting(null);
  });

  testWidgets('changing language logs analytics', (WidgetTester tester) async {
    final sink = _FakeAnalyticsSink();
    AppAnalytics.instance.setSinkForTesting(sink);

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => LocaleProvider(),
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: LanguageSettingsTile()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('drawer_language_tile')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('language_option_fr')));
    await tester.pumpAndSettle();

    expect(sink.events, isNotEmpty);
    expect(sink.events.single.name, 'language_changed');
    expect(sink.events.single.parameters['language'], 'fr');
    expect(sink.events.single.parameters['source_screen'], 'home_tab');
  });
}
