import 'package:flutter/material.dart';
import '../helpers/purchase_helper.dart';

class PurchaseProvider extends ChangeNotifier {
  bool _isPlus = false;
  String? _plusPriceString;

  bool get isPlus => _isPlus;

  /// Localized price string for the Plus product, e.g. "$2.99".
  /// Null until the first [refresh] completes or if the fetch fails.
  String? get plusPriceString => _plusPriceString;

  Future<void> refresh() async {
    _isPlus = await PurchaseHelper.isPlus();
    _plusPriceString ??= await PurchaseHelper.fetchPlusPrice();
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
