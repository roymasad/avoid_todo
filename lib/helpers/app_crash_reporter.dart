import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

abstract class CrashReporterSink {
  Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    String? reason,
    bool fatal,
  });
}

class FirebaseCrashReporterSink implements CrashReporterSink {
  FirebaseCrashReporterSink(this._crashlytics);

  final FirebaseCrashlytics _crashlytics;

  @override
  Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    String? reason,
    bool fatal = false,
  }) {
    return _crashlytics.recordError(
      error,
      stackTrace,
      reason: reason,
      fatal: fatal,
    );
  }
}

class AppCrashReporter {
  AppCrashReporter._();

  static final AppCrashReporter instance = AppCrashReporter._();

  CrashReporterSink? _sink;
  bool _enabled = false;

  bool get isEnabled => _enabled && _sink != null;

  void configure(FirebaseCrashlytics crashlytics) {
    _sink = FirebaseCrashReporterSink(crashlytics);
    _enabled = true;
  }

  @visibleForTesting
  void setSinkForTesting(CrashReporterSink? sink) {
    _sink = sink;
    _enabled = sink != null;
  }

  void disable() {
    _enabled = false;
    _sink = null;
  }

  Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    final sink = _sink;
    if (!_enabled || sink == null) {
      debugPrint(
        '[AppCrashReporter] reason=$reason fatal=$fatal error=$error\n$stackTrace',
      );
      return;
    }

    try {
      await sink.recordError(
        error,
        stackTrace,
        reason: reason,
        fatal: fatal,
      );
    } catch (reportError, reportStack) {
      debugPrint(
        '[AppCrashReporter] failed to report error: $reportError\n$reportStack',
      );
    }
  }

  void recordFlutterFatalError(FlutterErrorDetails details) {
    FlutterError.presentError(details);

    final stackTrace = details.stack ?? StackTrace.current;
    recordError(
      details.exception,
      stackTrace,
      reason: details.context?.toDescription(),
      fatal: true,
    );
  }
}
