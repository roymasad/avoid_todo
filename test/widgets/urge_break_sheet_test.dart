import 'package:avoid_todo/model/break_session.dart';
import 'package:avoid_todo/model/todo.dart';
import 'package:avoid_todo/l10n/app_localizations.dart';
import 'package:avoid_todo/widgets/urge_break_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _BreakHost extends StatefulWidget {
  final Duration duration;
  final bool showTrustedSupport;
  final BreakActivityType activityType;
  final void Function(BreakSessionResult?) onResult;
  final GlobalKey? sheetKey;

  const _BreakHost({
    required this.duration,
    required this.showTrustedSupport,
    required this.onResult,
    this.activityType = BreakActivityType.defuse,
    this.sheetKey,
  });

  @override
  State<_BreakHost> createState() => _BreakHostState();
}

class _BreakHostState extends State<_BreakHost> {
  Future<void> _open() async {
    final result = await showModalBottomSheet<BreakSessionResult>(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (_) => UrgeBreakSheet(
        key: widget.sheetKey,
        todo: ToDo(id: '1', todoText: 'Avoid midnight snack', tagIds: const []),
        activityType: widget.activityType,
        duration: widget.duration,
        showTrustedSupport: widget.showTrustedSupport,
      ),
    );
    widget.onResult(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: _open,
          child: const Text('Open'),
        ),
      ),
    );
  }
}

Future<void> _completeCurrentActivity(
    WidgetTester tester, GlobalKey sheetKey) async {
  (sheetKey.currentState as dynamic).debugCompleteCurrentActivity();
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
  await tester.pump(const Duration(seconds: 1));
}

void main() {
  test('stack blocker overlap ignores separated tiles', () {
    expect(
      UrgeBreakSheet.debugStackRectsCountAsBlocking(
        blockerRect: const Rect.fromLTWH(68, 24, 40, 22),
        blockedRect: const Rect.fromLTWH(24, 10, 40, 22),
      ),
      isFalse,
    );
  });

  test('stack blocker overlap still catches meaningful coverage', () {
    expect(
      UrgeBreakSheet.debugStackRectsCountAsBlocking(
        blockerRect: const Rect.fromLTWH(46, 18, 40, 22),
        blockedRect: const Rect.fromLTWH(24, 10, 40, 22),
      ),
      isTrue,
    );
  });

  testWidgets('timer completion shows the outcome view',
      (WidgetTester tester) async {
    BreakSessionResult? result;

    await tester.pumpWidget(
      MaterialApp(
        home: _BreakHost(
          duration: const Duration(seconds: 1),
          showTrustedSupport: false,
          onResult: (value) => result = value,
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byKey(const Key('break_timer')), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('break_outcome_view')), findsOneWidget);
    expect(result, isNull);
  });

  testWidgets('timer completion can continue the current activity',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: _BreakHost(
          duration: const Duration(seconds: 1),
          showTrustedSupport: false,
          onResult: (_) {},
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('break_outcome_view')), findsOneWidget);
    await tester.tap(find.byKey(const Key('break_continue_playing')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byKey(const Key('break_outcome_view')), findsNothing);
    expect(find.byKey(const Key('break_activity_defuse')), findsOneWidget);
    expect(find.text('00:30'), findsOneWidget);
  });

  testWidgets('finishing a completable activity opens feelings with replay',
      (WidgetTester tester) async {
    final sheetKey = GlobalKey();

    await tester.pumpWidget(
      MaterialApp(
        home: _BreakHost(
          duration: const Duration(seconds: 60),
          showTrustedSupport: false,
          onResult: (_) {},
          sheetKey: sheetKey,
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    await _completeCurrentActivity(tester, sheetKey);

    expect(find.byKey(const Key('break_outcome_view')), findsOneWidget);
    expect(find.byKey(const Key('break_replay_activity')), findsOneWidget);
  });

  testWidgets(
      'replaying after a completed scored activity shows a personal best',
      (WidgetTester tester) async {
    final sheetKey = GlobalKey();

    await tester.pumpWidget(
      MaterialApp(
        home: _BreakHost(
          duration: const Duration(seconds: 60),
          showTrustedSupport: false,
          activityType: BreakActivityType.defuse,
          onResult: (_) {},
          sheetKey: sheetKey,
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    await _completeCurrentActivity(tester, sheetKey);

    await tester.tap(find.byKey(const Key('break_replay_activity')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byKey(const Key('break_activity_defuse')), findsOneWidget);
    expect(find.byKey(const Key('break_personal_best')), findsOneWidget);
    expect(find.textContaining('Best:'), findsOneWidget);
  });

  testWidgets('best scored attempt survives replay and abort',
      (WidgetTester tester) async {
    BreakSessionResult? result;
    final sheetKey = GlobalKey();

    await tester.pumpWidget(
      MaterialApp(
        home: _BreakHost(
          duration: const Duration(seconds: 60),
          showTrustedSupport: false,
          activityType: BreakActivityType.defuse,
          onResult: (value) => result = value,
          sheetKey: sheetKey,
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    await _completeCurrentActivity(tester, sheetKey);

    await tester.tap(find.byKey(const Key('break_replay_activity')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    await tester.tap(find.byKey(const Key('break_sheet_close')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('Exit'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(result?.status, BreakSessionStatus.aborted);
    expect(result?.score, isNotNull);
    expect(result!.score!, greaterThan(0));
  });

  testWidgets('defuse activity exposes a bottom hint toggle',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: _BreakHost(
          duration: const Duration(seconds: 5),
          showTrustedSupport: false,
          activityType: BreakActivityType.defuse,
          onResult: (_) {},
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byKey(const Key('break_activity_defuse')), findsOneWidget);
    expect(find.byKey(const Key('defuse_hint_toggle')), findsOneWidget);
    expect(find.text('Hints off'), findsOneWidget);

    await tester.ensureVisible(find.byKey(const Key('defuse_hint_toggle')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('defuse_hint_toggle')));
    await tester.pump();

    expect(find.text('Hints on'), findsOneWidget);
  });

  testWidgets('defuse center label stays as Tap in other locales',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: _BreakHost(
          duration: const Duration(seconds: 5),
          showTrustedSupport: false,
          activityType: BreakActivityType.defuse,
          onResult: (_) {},
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(
      find.descendant(
        of: find.byKey(const Key('defuse_safe_crack')),
        matching: find.text('Tap'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('defuse needle keeps moving while the activity is active',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: _BreakHost(
          duration: const Duration(seconds: 5),
          showTrustedSupport: false,
          activityType: BreakActivityType.defuse,
          onResult: (_) {},
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    final paintFinder = find.descendant(
      of: find.byKey(const Key('defuse_safe_crack')),
      matching: find.byType(CustomPaint),
    );
    final firstPainter =
        tester.widget<CustomPaint>(paintFinder).painter as dynamic;
    final firstNeedleTurn = firstPainter.needleTurn as double;

    await tester.pump(const Duration(milliseconds: 200));

    final secondPainter =
        tester.widget<CustomPaint>(paintFinder).painter as dynamic;
    final secondNeedleTurn = secondPainter.needleTurn as double;

    expect(secondNeedleTurn, isNot(equals(firstNeedleTurn)));
  });

  testWidgets('pause button freezes and resumes the break timer',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: _BreakHost(
          duration: const Duration(seconds: 5),
          showTrustedSupport: false,
          activityType: BreakActivityType.defuse,
          onResult: (_) {},
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('00:05'), findsOneWidget);

    await tester.tap(find.byKey(const Key('break_pause_toggle')));
    await tester.pump();

    await tester.pump(const Duration(seconds: 2));
    expect(find.text('00:05'), findsOneWidget);

    await tester.tap(find.byKey(const Key('break_pause_toggle')));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('00:04'), findsOneWidget);
  });

  testWidgets('early exit requires confirmation and returns aborted status',
      (WidgetTester tester) async {
    BreakSessionResult? result;

    await tester.pumpWidget(
      MaterialApp(
        home: _BreakHost(
          duration: const Duration(seconds: 5),
          showTrustedSupport: false,
          onResult: (value) => result = value,
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.byKey(const Key('break_sheet_close')));
    await tester.pumpAndSettle();

    expect(find.text('Leave this break?'), findsOneWidget);
    await tester.tap(find.text('Exit'));
    await tester.pumpAndSettle();

    expect(result?.status, BreakSessionStatus.aborted);
  });

  testWidgets('still strong reveals follow-up actions',
      (WidgetTester tester) async {
    BreakSessionResult? result;

    await tester.pumpWidget(
      MaterialApp(
        home: _BreakHost(
          duration: const Duration(seconds: 1),
          showTrustedSupport: true,
          onResult: (value) => result = value,
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(const Key('break_outcome_strong')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('break_outcome_strong')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('break_followup_retry')), findsOneWidget);
    expect(find.byKey(const Key('break_followup_zen')), findsOneWidget);
    expect(find.byKey(const Key('break_followup_support')), findsOneWidget);

    await tester.ensureVisible(find.byKey(const Key('break_followup_retry')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('break_followup_retry')));
    await tester.pumpAndSettle();

    expect(result?.outcome, BreakOutcome.stillStrong);
    expect(result?.followUpAction, BreakFollowUpAction.retry);
  });

  testWidgets('zen room uses rain area instead of prompt button',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: _BreakHost(
          duration: const Duration(seconds: 5),
          showTrustedSupport: false,
          activityType: BreakActivityType.zenRoom,
          onResult: (_) {},
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byKey(const Key('break_activity_zen')), findsOneWidget);
    expect(find.byKey(const Key('zen_room_rain_area')), findsOneWidget);
    expect(find.byKey(const Key('zen_room_prompt')), findsNothing);
    expect(find.textContaining('Tap a drop'), findsWidgets);
  });

  testWidgets('trivia hints remove one false answer when enabled',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: _BreakHost(
          duration: const Duration(seconds: 5),
          showTrustedSupport: false,
          activityType: BreakActivityType.triviaPivot,
          onResult: (_) {},
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('break_activity_trivia')), findsOneWidget);
    expect(find.byKey(const Key('trivia_hint_toggle')), findsOneWidget);
    expect(find.text('Hints off'), findsOneWidget);
    expect(find.byType(OutlinedButton), findsNWidgets(3));

    await tester.ensureVisible(find.byKey(const Key('trivia_hint_toggle')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('trivia_hint_toggle')));
    await tester.pump();

    expect(find.text('Hints on'), findsOneWidget);
    expect(find.byType(OutlinedButton), findsNWidgets(2));
  });

  testWidgets('pair match exposes a hint toggle', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: _BreakHost(
          duration: const Duration(seconds: 5),
          showTrustedSupport: false,
          activityType: BreakActivityType.pairMatch,
          onResult: (_) {},
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('break_activity_pairs')), findsOneWidget);
    expect(find.byKey(const Key('pair_hint_toggle')), findsOneWidget);
    expect(find.text('Hints off'), findsOneWidget);

    await tester.ensureVisible(find.byKey(const Key('pair_hint_toggle')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('pair_hint_toggle')));
    await tester.pump();

    expect(find.text('Hints on'), findsOneWidget);
  });

  testWidgets('pair match cards flip when revealed',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: _BreakHost(
          duration: const Duration(seconds: 5),
          showTrustedSupport: false,
          activityType: BreakActivityType.pairMatch,
          onResult: (_) {},
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('pair_card_0')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    final midFlip = tester.widget<Transform>(
      find.byKey(const Key('pair_card_flip_0')),
    );
    expect(midFlip.transform.storage[0], isNot(closeTo(1, 0.001)));

    await tester.pumpAndSettle();

    final settled = tester.widget<Transform>(
      find.byKey(const Key('pair_card_flip_0')),
    );
    expect(settled.transform.storage[0], closeTo(1, 0.001));
    expect(
      find.descendant(
        of: find.byKey(const Key('pair_card_0')),
        matching: find.text('?'),
      ),
      findsNothing,
    );
  });

  testWidgets('stack sweep activity renders its board',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: _BreakHost(
          duration: const Duration(seconds: 5),
          showTrustedSupport: false,
          activityType: BreakActivityType.stackSweep,
          onResult: (_) {},
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('break_activity_stack')), findsOneWidget);
    expect(find.byKey(const Key('stack_sweep_board')), findsOneWidget);
    expect(find.byKey(const Key('stack_tile_0')), findsOneWidget);
    expect(find.byKey(const Key('stack_hint_toggle')), findsOneWidget);
    expect(find.text('Hints off'), findsOneWidget);

    await tester.ensureVisible(find.byKey(const Key('stack_hint_toggle')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('stack_hint_toggle')));
    await tester.pump();

    expect(find.text('Hints on'), findsOneWidget);
  });

  testWidgets('cube reset activity renders the cube and controls',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: _BreakHost(
          duration: const Duration(seconds: 5),
          showTrustedSupport: false,
          activityType: BreakActivityType.cubeReset,
          onResult: (_) {},
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byKey(const Key('break_activity_cube')), findsOneWidget);
    expect(find.byKey(const Key('cube_scene')), findsOneWidget);
    expect(find.byKey(const Key('cube_hint_toggle')), findsOneWidget);
    expect(find.text('Hints off'), findsOneWidget);
    expect(find.textContaining('Solved '), findsOneWidget);

    await tester.tap(find.byKey(const Key('cube_hint_toggle')));
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.text('Choose hint strength'), findsOneWidget);
    expect(find.text('A bit of help'), findsOneWidget);
    expect(find.text('A lot of help'), findsOneWidget);

    await tester.tap(find.text('A bit of help'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.text('Hints: a bit'), findsOneWidget);
  });
}
