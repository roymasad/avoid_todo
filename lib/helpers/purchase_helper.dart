import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'app_crash_reporter.dart';

class PurchaseHelper {
  static const String _iosApiKey = 'appl_zqGbenJyFgbjTqbrrvRxIyTgCHW';
  static const String _androidApiKey = 'goog_hUpFgpnCzfiuHXDDozLWqHprNRh';

  static const String entitlementId = 'plus';

  static Future<void> init() async {
    if (kDebugMode) {
      await Purchases.setLogLevel(LogLevel.debug);
      await Purchases.setLogHandler((level, message) {
        debugPrint('[RevenueCat/${level.name}] $message');
      });
    }

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
      if (package == null) {
        debugPrint(
            '[PurchaseHelper] No lifetime package available in current offering.');
        return false;
      }

      debugPrint(
        '[PurchaseHelper] Purchasing package=${package.identifier} '
        'product=${package.storeProduct.identifier}',
      );
      final result = await Purchases.purchase(PurchaseParams.package(package));
      final hasEntitlement = _hasPlusEntitlement(result.customerInfo);
      debugPrint(
        '[PurchaseHelper] purchase result entitlements='
        '${result.customerInfo.entitlements.active.keys.toList()} '
        'hasPlus=$hasEntitlement',
      );
      if (hasEntitlement) return true;

      await Purchases.invalidateCustomerInfoCache();
      final refreshed = await Purchases.getCustomerInfo();
      final refreshedHasEntitlement = _hasPlusEntitlement(refreshed);
      debugPrint(
        '[PurchaseHelper] refreshed customer info entitlements='
        '${refreshed.entitlements.active.keys.toList()} '
        'hasPlus=$refreshedHasEntitlement',
      );
      return refreshedHasEntitlement;
    } on PlatformException catch (e, stackTrace) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      debugPrint(
        '[PurchaseHelper] purchase error '
        'code=${e.code} parsed=$errorCode message=${e.message} details=${e.details}',
      );
      debugPrintStack(
        label: '[PurchaseHelper] purchase stack',
        stackTrace: stackTrace,
      );
      if (errorCode == PurchasesErrorCode.productAlreadyPurchasedError) {
        await Purchases.invalidateCustomerInfoCache();
        final customerInfo = await Purchases.getCustomerInfo();
        final hasEntitlement = _hasPlusEntitlement(customerInfo);
        debugPrint(
          '[PurchaseHelper] product already purchased, refreshed entitlements='
          '${customerInfo.entitlements.active.keys.toList()} '
          'hasPlus=$hasEntitlement',
        );
        return hasEntitlement;
      }
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        await AppCrashReporter.instance.recordError(
          e,
          stackTrace,
          reason: 'purchase_plus_platform_exception',
        );
      }
      return false;
    } catch (e, stackTrace) {
      debugPrint('[PurchaseHelper] purchase unexpected error: $e');
      debugPrintStack(
        label: '[PurchaseHelper] unexpected purchase stack',
        stackTrace: stackTrace,
      );
      await AppCrashReporter.instance.recordError(
        e,
        stackTrace,
        reason: 'purchase_plus_unexpected',
      );
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
      final hasEntitlement = _hasPlusEntitlement(customerInfo);
      debugPrint(
        '[PurchaseHelper] restore entitlements='
        '${customerInfo.entitlements.active.keys.toList()} '
        'hasPlus=$hasEntitlement',
      );
      return hasEntitlement;
    } catch (_) {
      return false;
    }
  }

  static bool _hasPlusEntitlement(CustomerInfo customerInfo) {
    return customerInfo.entitlements.active.containsKey(entitlementId);
  }
}
