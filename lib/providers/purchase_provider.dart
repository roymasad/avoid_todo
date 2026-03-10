import 'package:flutter/material.dart';

import '../helpers/purchase_helper.dart';
import '../helpers/trial_repository.dart';
import '../model/trial_status.dart';

class PurchaseProvider extends ChangeNotifier {
  PurchaseProvider({TrialRepository? trialRepository})
      : _trialRepository = trialRepository ?? TrialRepository.create();

  final TrialRepository? _trialRepository;

  bool _hasPurchasedPlus = false;
  bool _isAccessStateResolved = false;
  String? _plusPriceString;
  TrialStatus? _trialStatus;

  bool get isPlus => hasPlusAccess;
  bool get hasPurchasedPlus => _hasPurchasedPlus;
  bool get hasActiveTrial => _trialStatus?.isActive ?? false;
  bool get hasPlusAccess => _hasPurchasedPlus || hasActiveTrial;
  bool get isAccessStateResolved => _isAccessStateResolved;
  TrialStatus? get trialStatus => _trialStatus;

  /// Localized price string for the Plus product, e.g. "$2.99".
  /// Null until the first [refresh] completes or if the fetch fails.
  String? get plusPriceString => _plusPriceString;

  Future<void> refresh() async {
    _isAccessStateResolved = false;
    notifyListeners();

    _hasPurchasedPlus = await PurchaseHelper.isPlus();
    _trialStatus = await _trialRepository?.loadStatus();
    _plusPriceString ??= await PurchaseHelper.fetchPlusPrice();
    _isAccessStateResolved = true;
    notifyListeners();
  }

  Future<bool> purchasePlus() async {
    final result = await PurchaseHelper.purchasePlus();
    if (result) {
      _hasPurchasedPlus = true;
      _isAccessStateResolved = true;
      notifyListeners();
    }
    return result;
  }

  Future<bool> restorePurchases() async {
    final result = await PurchaseHelper.restorePurchases();
    if (result) {
      _hasPurchasedPlus = true;
      _isAccessStateResolved = true;
      notifyListeners();
    }
    return result;
  }

  Future<bool> canStartTrial() async {
    return await _trialRepository?.isAvailableForTrial() ?? false;
  }

  Future<TrialStartResult> startTrial() async {
    final result = await _trialRepository?.startTrial() ??
        const TrialStartResult(outcome: TrialStartOutcome.unavailable);
    if (result.status != null) {
      _trialStatus = result.status;
    }
    _isAccessStateResolved = true;
    notifyListeners();
    return result;
  }

  Future<TrialDebugState?> trialDebugState() async {
    return await _trialRepository?.debugState();
  }

  Future<bool> resetTrialDebugState() async {
    final cleared = await _trialRepository?.clearStatus() ?? false;
    if (!cleared) return false;
    _trialStatus = null;
    _isAccessStateResolved = true;
    notifyListeners();
    return true;
  }

  Future<bool> expireTrialDebugState() async {
    final expired = await _trialRepository?.expireStatus() ?? false;
    if (!expired) return false;
    _trialStatus = await _trialRepository?.loadStatus();
    _isAccessStateResolved = true;
    notifyListeners();
    return true;
  }
}
