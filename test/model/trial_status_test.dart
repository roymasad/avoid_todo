import 'package:flutter_test/flutter_test.dart';

import 'package:avoid_todo/model/trial_status.dart';

void main() {
  group('TrialStatus', () {
    test('clamps device time to the last seen timestamp', () {
      final status = TrialStatus(
        startedAtUtc: DateTime.utc(2026, 3, 1),
        expiresAtUtc: DateTime.utc(2026, 3, 11),
        lastSeenAtUtc: DateTime.utc(2026, 3, 5),
        accountKey: 'account-1',
        source: TrialSource.googleDriveAppData,
      );

      final refreshed = status.refreshed(DateTime.utc(2026, 3, 3));

      expect(refreshed.lastSeenAtUtc, DateTime.utc(2026, 3, 5));
      expect(refreshed.isActive, isTrue);
    });

    test('serializes and deserializes without losing fields', () {
      final status = TrialStatus.start(
        nowUtc: DateTime.utc(2026, 3, 10, 8),
        accountKey: 'account-2',
        source: TrialSource.iCloudKvStore,
      );

      final decoded = TrialStatus.fromJson(status.toJson());

      expect(decoded, isNotNull);
      expect(decoded!.accountKey, 'account-2');
      expect(decoded.source, TrialSource.iCloudKvStore);
      expect(decoded.expiresAtUtc, DateTime.utc(2026, 3, 20, 8));
    });
  });
}
