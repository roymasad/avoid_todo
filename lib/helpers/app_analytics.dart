import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

abstract class AnalyticsSink {
  Future<void> logEvent(String name, Map<String, Object> parameters);
  Future<void> logScreenView(String screenName, {String? screenClass});
}

class FirebaseAnalyticsSink implements AnalyticsSink {
  FirebaseAnalyticsSink(this._analytics);

  final FirebaseAnalytics _analytics;

  @override
  Future<void> logEvent(String name, Map<String, Object> parameters) {
    return _analytics.logEvent(name: name, parameters: parameters);
  }

  @override
  Future<void> logScreenView(String screenName, {String? screenClass}) {
    return _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass ?? screenName,
    );
  }
}

class AppAnalytics {
  AppAnalytics._();

  static final AppAnalytics instance = AppAnalytics._();

  AnalyticsSink? _sink;
  bool _enabled = false;

  bool get isEnabled => _enabled && _sink != null;

  void configure(FirebaseAnalytics analytics) {
    _sink = FirebaseAnalyticsSink(analytics);
    _enabled = true;
  }

  @visibleForTesting
  void setSinkForTesting(AnalyticsSink? sink) {
    _sink = sink;
    _enabled = sink != null;
  }

  void disable() {
    _enabled = false;
    _sink = null;
  }

  Future<void> trackScreen(String screenName, {String? screenClass}) async {
    final sink = _sink;
    if (!_enabled || sink == null) return;

    try {
      await sink.logScreenView(
        screenName,
        screenClass: screenClass ?? screenName,
      );
    } catch (error, stackTrace) {
      debugPrint(
        '[AppAnalytics] screen=$screenName failed: $error\n$stackTrace',
      );
    }
  }

  Future<void> trackEvent(
    String eventName, {
    Map<String, Object?> parameters = const {},
  }) async {
    final sink = _sink;
    if (!_enabled || sink == null) return;

    final sanitized = _sanitizeParameters(parameters);

    try {
      await sink.logEvent(eventName, sanitized);
    } catch (error, stackTrace) {
      debugPrint(
        '[AppAnalytics] event=$eventName failed: $error\n$stackTrace',
      );
    }
  }

  Map<String, Object> _sanitizeParameters(Map<String, Object?> parameters) {
    final sanitized = <String, Object>{
      'platform': Platform.isIOS ? 'ios' : 'android',
    };

    for (final entry in parameters.entries) {
      final key = entry.key.trim();
      if (key.isEmpty) continue;

      final value = entry.value;
      if (value == null) continue;

      if (value is bool) {
        sanitized[key] = value ? 1 : 0;
        continue;
      }

      if (value is int || value is double || value is String) {
        sanitized[key] = value;
      }
    }

    return sanitized;
  }
}
