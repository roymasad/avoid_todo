import 'dart:io';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseHelper {
  static const String _iosApiKey = 'appl_zqGbenJyFgbjTqbrrvRxIyTgCHW';
  static const String _androidApiKey = 'goog_hUpFgpnCzfiuHXDDozLWqHprNRh';

  static const String entitlementId = 'plus';

  static Future<void> init() async {
    final configuration = PurchasesConfiguration(
      Platform.isIOS ? _iosApiKey : _androidApiKey,
    );
    await Purchases.configure(configuration);
  }

  static Future<bool> isPlus() async {
    try {
      await Purchases.invalidateCustomerInfoCache();
      final customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.active.containsKey(entitlementId);
    } catch (_) {
      return false;
    }
  }

  static Future<bool> purchasePlus() async {
    try {
      final offerings = await Purchases.getOfferings();
      final package = offerings.current?.lifetime;
      if (package == null) return false;
      final result = await Purchases.purchase(PurchaseParams.package(package));
      return result.customerInfo.entitlements.active.containsKey(entitlementId);
    } catch (_) {
      return false;
    }
  }

  /// Returns the localized price string for the Plus product (e.g. "$2.99").
  /// Falls back to null if the offering cannot be fetched.
  static Future<String?> fetchPlusPrice() async {
    try {
      final offerings = await Purchases.getOfferings();
      return offerings.current?.lifetime?.storeProduct.priceString;
    } catch (_) {
      return null;
    }
  }

  static Future<bool> restorePurchases() async {
    try {
      final customerInfo = await Purchases.restorePurchases();
      return customerInfo.entitlements.active.containsKey(entitlementId);
    } catch (_) {
      return false;
    }
  }
}
