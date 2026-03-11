import 'package:flutter_test/flutter_test.dart';

import 'package:avoid_todo/helpers/trial_repository.dart';
import 'package:avoid_todo/model/trial_status.dart';
import 'package:avoid_todo/providers/purchase_provider.dart';

class _FakeTrialRepository implements TrialRepository {
  _FakeTrialRepository({
    this.status,
    this.startResult =
        const TrialStartResult(outcome: TrialStartOutcome.unavailable),
    this.clearResult = true,
    this.expireResult = true,
  });

  final TrialStatus? status;
  final TrialStartResult startResult;
  final bool clearResult;
  final bool expireResult;

  @override
  Future<bool> isAvailableForTrial() async => true;

  @override
  Future<TrialStatus?> loadStatus() async => status;

  @override
  Future<TrialStartResult> startTrial() async => startResult;

  @override
  Future<bool> clearStatus() async => clearResult;

  @override
  Future<bool> expireStatus() async => expireResult;

  @override
  Future<TrialDebugState> debugState() async => TrialDebugState(
        storageLabel: 'fake',
        isStorageAvailable: true,
        hasCachedStatus: status != null,
        status: status,
      );
}

void main() {
  group('PurchaseProvider', () {
    test('turns an active trial into Plus access', () async {
      final status = TrialStatus.start(
        nowUtc: DateTime.utc(2026, 3, 10),
        accountKey: 'account-1',
        source: TrialSource.googleDriveAppData,
      );
      final provider = PurchaseProvider(
        trialRepository: _FakeTrialRepository(status: status),
      );

      await provider.refresh();

      expect(provider.hasPurchasedPlus, isFalse);
      expect(provider.hasActiveTrial, isTrue);
      expect(provider.hasPlusAccess, isTrue);
      expect(provider.isAccessStateResolved, isTrue);
    });

    test('stores a newly started trial result', () async {
      final status = TrialStatus.start(
        nowUtc: DateTime.utc(2026, 3, 10),
        accountKey: 'account-2',
        source: TrialSource.iCloudKvStore,
      );
      final provider = PurchaseProvider(
        trialRepository: _FakeTrialRepository(
          startResult: TrialStartResult(
            outcome: TrialStartOutcome.started,
            status: status,
          ),
        ),
      );

      final result = await provider.startTrial();

      expect(result.outcome, TrialStartOutcome.started);
      expect(provider.hasActiveTrial, isTrue);
      expect(provider.trialStatus?.accountKey, 'account-2');
    });

    test('debug override grants trial access without storage', () async {
      final provider = PurchaseProvider(
        trialRepository: _FakeTrialRepository(
          clearResult: false,
          expireResult: false,
        ),
      );

      final status = await provider.grantDebugTrialAccess();

      expect(provider.hasActiveTrial, isTrue);
      expect(provider.hasPlusAccess, isTrue);
      expect(provider.hasDebugTrialOverride, isTrue);
      expect(provider.trialStatus?.source, TrialSource.debugOverride);
      expect(provider.trialStatus?.accountKey, 'debug_override');
      expect(status.isActive, isTrue);
    });

    test('reset clears debug override even when repository clear fails',
        () async {
      final provider = PurchaseProvider(
        trialRepository: _FakeTrialRepository(clearResult: false),
      );

      await provider.grantDebugTrialAccess();
      final cleared = await provider.resetTrialDebugState();

      expect(cleared, isTrue);
      expect(provider.hasDebugTrialOverride, isFalse);
      expect(provider.hasActiveTrial, isFalse);
      expect(provider.trialStatus, isNull);
    });
  });
}
