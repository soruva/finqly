import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:flutter/foundation.dart';

class SubscriptionManager {
  static const _subscriptionKey = 'isSubscribed';
  static const _productId = 'finqly_plus_subscription';

  final ValueNotifier<bool> isSubscribedNotifier = ValueNotifier(false);

  bool get isSubscribed => isSubscribedNotifier.value;

  // TODO: Replace local storage with proper Google Play subscription verification!
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool(_subscriptionKey) ?? false;
    isSubscribedNotifier.value = value;
    // WARNING: Real app should check subscription status with Google Play (server-side verification).
  }

  Future<bool> checkSubscription() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool(_subscriptionKey) ?? false;
    isSubscribedNotifier.value = value;
    // WARNING: Only using local cache. Must implement Play Store validation!
    return value;
  }

  Future<void> buyPremium() async {
    final available = await InAppPurchase.instance.isAvailable();
    if (!available) throw Exception('In-app purchases not available');

    final purchaseParam = PurchaseParam(productDetails: await _getProductDetails());
    // TODO: For subscriptions, use buySubscription instead of buyNonConsumable!
    final result = await InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);

    await _setPremium(true);
    // WARNING: In production, unlock premium ONLY after validating purchaseToken with Google server.
  }

  Future<ProductDetails> _getProductDetails() async {
    final response = await InAppPurchase.instance.queryProductDetails({_productId});
    if (response.notFoundIDs.isNotEmpty) throw Exception('Product not found');
    return response.productDetails.first;
  }

  Future<void> _setPremium(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_subscriptionKey, value);
    isSubscribedNotifier.value = value;
  }

  Future<void> refreshSubscriptionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool(_subscriptionKey) ?? false;
    isSubscribedNotifier.value = value;
  }

  Future<void> setSubscribed(bool value) async {
    await _setPremium(value);
  }
}
