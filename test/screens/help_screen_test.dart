import 'package:avoid_todo/l10n/app_localizations.dart';
import 'package:avoid_todo/screens/help_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('help screen shows analytics privacy FAQ',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: HelpScreen(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('What analytics does Avoid collect?'),
      300,
    );
    await tester.tap(find.text('What analytics does Avoid collect?'));
    await tester.pumpAndSettle();

    expect(find.text('What analytics does Avoid collect?'), findsOneWidget);
    expect(
      find.textContaining('basic app usage analytics'),
      findsOneWidget,
    );
  });
}
