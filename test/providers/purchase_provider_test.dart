import 'package:flutter_test/flutter_test.dart';

import 'package:avoid_todo/helpers/trial_repository.dart';
import 'package:avoid_todo/model/trial_status.dart';
import 'package:avoid_todo/providers/purchase_provider.dart';

class _FakeTrialRepository implements TrialRepository {
  _FakeTrialRepository({
    this.status,
    this.startResult =
        const TrialStartResult(outcome: TrialStartOutcome.unavailable),
  });

  final TrialStatus? status;
  final TrialStartResult startResult;

  @override
  Future<bool> isAvailableForTrial() async => true;

  @override
  Future<TrialStatus?> loadStatus() async => status;

  @override
  Future<TrialStartResult> startTrial() async => startResult;

  @override
  Future<bool> clearStatus() async => true;

  @override
  Future<bool> expireStatus() async => true;

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
  });
}
