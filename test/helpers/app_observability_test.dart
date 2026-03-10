import 'package:avoid_todo/helpers/app_analytics.dart';
import 'package:avoid_todo/helpers/app_crash_reporter.dart';
import 'package:flutter_test/flutter_test.dart';

class _CapturedEvent {
  const _CapturedEvent(this.name, this.parameters);

  final String name;
  final Map<String, Object> parameters;
}

class _FakeAnalyticsSink implements AnalyticsSink {
  final List<_CapturedEvent> events = [];
  final List<String> screenViews = [];

  @override
  Future<void> logEvent(String name, Map<String, Object> parameters) async {
    events.add(_CapturedEvent(name, Map<String, Object>.from(parameters)));
  }

  @override
  Future<void> logScreenView(String screenName, {String? screenClass}) async {
    screenViews.add(screenName);
  }
}

class _CapturedCrash {
  const _CapturedCrash(this.error, this.stackTrace, this.reason, this.fatal);

  final Object error;
  final StackTrace stackTrace;
  final String? reason;
  final bool fatal;
}

class _FakeCrashSink implements CrashReporterSink {
  final List<_CapturedCrash> crashes = [];

  @override
  Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    crashes.add(_CapturedCrash(error, stackTrace, reason, fatal));
  }
}

void main() {
  tearDown(() {
    AppAnalytics.instance.setSinkForTesting(null);
    AppCrashReporter.instance.setSinkForTesting(null);
  });

  test('AppAnalytics sanitizes params and adds platform', () async {
    final sink = _FakeAnalyticsSink();
    AppAnalytics.instance.setSinkForTesting(sink);

    await AppAnalytics.instance.trackEvent(
      'todo_add_submitted',
      parameters: {
        'source_screen': 'home_tab',
        'has_plus': true,
        'count': 3,
        'ratio': 1.5,
        'ignored_null': null,
        'ignored_list': const ['x'],
      },
    );

    expect(sink.events, hasLength(1));
    expect(sink.events.single.name, 'todo_add_submitted');
    expect(sink.events.single.parameters['source_screen'], 'home_tab');
    expect(sink.events.single.parameters['has_plus'], 1);
    expect(sink.events.single.parameters['count'], 3);
    expect(sink.events.single.parameters['ratio'], 1.5);
    expect(sink.events.single.parameters.containsKey('ignored_null'), isFalse);
    expect(sink.events.single.parameters.containsKey('ignored_list'), isFalse);
    expect(sink.events.single.parameters.containsKey('platform'), isTrue);
  });

  test('AppAnalytics records screen views', () async {
    final sink = _FakeAnalyticsSink();
    AppAnalytics.instance.setSinkForTesting(sink);

    await AppAnalytics.instance.trackScreen('help_screen');

    expect(sink.screenViews, ['help_screen']);
  });

  test('AppCrashReporter forwards non-fatal errors', () async {
    final sink = _FakeCrashSink();
    AppCrashReporter.instance.setSinkForTesting(sink);
    final stackTrace = StackTrace.current;

    await AppCrashReporter.instance.recordError(
      StateError('boom'),
      stackTrace,
      reason: 'test_reason',
    );

    expect(sink.crashes, hasLength(1));
    expect(sink.crashes.single.reason, 'test_reason');
    expect(sink.crashes.single.fatal, isFalse);
    expect(sink.crashes.single.stackTrace, stackTrace);
  });
}
