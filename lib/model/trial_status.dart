enum TrialSource {
  iCloudKvStore,
  googleDriveAppData,
  debugOverride,
}

enum TrialStartOutcome {
  started,
  activeExisting,
  expiredExisting,
  unavailable,
  cancelled,
  failed,
}

class TrialStatus {
  TrialStatus({
    required this.startedAtUtc,
    required this.expiresAtUtc,
    required this.lastSeenAtUtc,
    required this.accountKey,
    required this.source,
  });

  static const String storageKey = 'plus_trial_state_v1';
  static const String fileName = 'trial_state.json';
  static const Duration trialDuration = Duration(days: 10);

  final DateTime startedAtUtc;
  final DateTime expiresAtUtc;
  final DateTime lastSeenAtUtc;
  final String accountKey;
  final TrialSource source;

  bool get isActive => expiresAtUtc.isAfter(lastSeenAtUtc);

  DateTime effectiveNow(DateTime deviceNowUtc) {
    final normalizedNow = deviceNowUtc.toUtc();
    return normalizedNow.isAfter(lastSeenAtUtc) ? normalizedNow : lastSeenAtUtc;
  }

  TrialStatus refreshed(DateTime deviceNowUtc) {
    return copyWith(lastSeenAtUtc: effectiveNow(deviceNowUtc));
  }

  TrialStatus copyWith({
    DateTime? startedAtUtc,
    DateTime? expiresAtUtc,
    DateTime? lastSeenAtUtc,
    String? accountKey,
    TrialSource? source,
  }) {
    return TrialStatus(
      startedAtUtc: startedAtUtc ?? this.startedAtUtc,
      expiresAtUtc: expiresAtUtc ?? this.expiresAtUtc,
      lastSeenAtUtc: lastSeenAtUtc ?? this.lastSeenAtUtc,
      accountKey: accountKey ?? this.accountKey,
      source: source ?? this.source,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': 1,
      'startedAtUtc': startedAtUtc.toIso8601String(),
      'expiresAtUtc': expiresAtUtc.toIso8601String(),
      'lastSeenAtUtc': lastSeenAtUtc.toIso8601String(),
      'accountKey': accountKey,
      'source': source.name,
    };
  }

  static TrialStatus? fromJson(Map<String, dynamic> json) {
    final startedAt = _parseDateTime(json['startedAtUtc']);
    final expiresAt = _parseDateTime(json['expiresAtUtc']);
    final lastSeenAt = _parseDateTime(json['lastSeenAtUtc']);
    final accountKey = json['accountKey'] as String?;
    final sourceName = json['source'] as String?;
    if (startedAt == null ||
        expiresAt == null ||
        lastSeenAt == null ||
        accountKey == null ||
        sourceName == null) {
      return null;
    }

    TrialSource? source;
    for (final candidate in TrialSource.values) {
      if (candidate.name == sourceName) {
        source = candidate;
        break;
      }
    }
    if (source == null) return null;

    return TrialStatus(
      startedAtUtc: startedAt,
      expiresAtUtc: expiresAt,
      lastSeenAtUtc: lastSeenAt,
      accountKey: accountKey,
      source: source,
    );
  }

  static TrialStatus start({
    required DateTime nowUtc,
    required String accountKey,
    required TrialSource source,
  }) {
    final startedAt = nowUtc.toUtc();
    return TrialStatus(
      startedAtUtc: startedAt,
      expiresAtUtc: startedAt.add(trialDuration),
      lastSeenAtUtc: startedAt,
      accountKey: accountKey,
      source: source,
    );
  }

  static DateTime? _parseDateTime(dynamic rawValue) {
    if (rawValue is! String) return null;
    return DateTime.tryParse(rawValue)?.toUtc();
  }
}

class TrialStartResult {
  const TrialStartResult({
    required this.outcome,
    this.status,
  });

  final TrialStartOutcome outcome;
  final TrialStatus? status;

  bool get startedOrActive =>
      outcome == TrialStartOutcome.started ||
      outcome == TrialStartOutcome.activeExisting;
}
