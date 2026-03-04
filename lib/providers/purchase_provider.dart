import 'package:flutter/material.dart';
import '../helpers/purchase_helper.dart';

class PurchaseProvider extends ChangeNotifier {
  bool _isPlus = false;

  bool get isPlus => _isPlus;

  Future<void> refresh() async {
    _isPlus = await PurchaseHelper.isPlus();
    notifyListeners();
  }

  Future<bool> purchasePlus() async {
    final result = await PurchaseHelper.purchasePlus();
    if (result) {
      _isPlus = true;
      notifyListeners();
    }
    return result;
  }

  Future<bool> restorePurchases() async {
    final result = await PurchaseHelper.restorePurchases();
    if (result) {
      _isPlus = true;
      notifyListeners();
    }
    return result;
  }
}
