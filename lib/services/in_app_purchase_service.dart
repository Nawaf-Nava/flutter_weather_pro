import 'dart:io';

import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class InAppPurchaseService {
  static const String _apiKeyAndroid = 'goog_your_revenuecat_android_key';
  static const String _apiKeyIos = 'appl_your_revenuecat_ios_key';
  static const String proEntitlementId = 'weather_pro_vip';

  static Future<void> initialize() async {
    await Purchases.setLogLevel(LogLevel.warn);
    final configuration = PurchasesConfiguration(
      Platform.isAndroid ? _apiKeyAndroid : _apiKeyIos,
    );
    await Purchases.configure(configuration);
  }

  /// التحقق مما إذا كان المستخدم مشتركاً في باقة PRO
  static Future<bool> isUserPro() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.all[proEntitlementId]?.isActive ?? false;
    } on PlatformException {
      return false;
    }
  }

  /// جلب الباقات المتاحة (سنوي / شهري / مدى الحياة)
  static Future<List<Package>> fetchOfferings() async {
    try {
      final offerings = await Purchases.getOfferings();
      if (offerings.current != null && offerings.current!.availablePackages.isNotEmpty) {
        return offerings.current!.availablePackages;
      }
    } catch (e) {
      // الخطأ عند جلب العروض
    }
    return [];
  }

  /// تنفيذ عملية الشراء
  static Future<bool> purchasePackage(Package package) async {
    try {
      final customerInfo = await Purchases.purchasePackage(package);
      return customerInfo.entitlements.all[proEntitlementId]?.isActive ?? false;
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        // خطأ آخر
      }
      return false;
    }
  }

  /// استعادة المشتريات السابقة (Restore Purchases)
  static Future<bool> restorePurchases() async {
    try {
      final customerInfo = await Purchases.restorePurchases();
      return customerInfo.entitlements.all[proEntitlementId]?.isActive ?? false;
    } catch (e) {
      return false;
    }
  }
}