import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:flutter/foundation.dart';

class SubscriptionManager {
  static const _subscriptionKey = 'isSubscribed';
  static const _productId = 'finqly_plus_subscription';

  /// ← ここがValueNotifier
  final ValueNotifier<bool> isSubscribedNotifier = ValueNotifier(false);

  // getter（古いisSubscribedもラップ）
  bool get isSubscribed => isSubscribedNotifier.value;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool(_subscriptionKey) ?? false;
    isSubscribedNotifier.value = value;
  }

  Future<bool> checkSubscription() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool(_subscriptionKey) ?? false;
    isSubscribedNotifier.value = value; // ← ここも反映
    return value;
  }

  Future<void> buyPremium() async {
    final available = await InAppPurchase.instance.isAvailable();
    if (!available) throw Exception('In-app purchases not available');

    final purchaseParam = PurchaseParam(productDetails: await _getProductDetails());
    final result = await InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);

    // 本番は purchaseUpdatedStream で検証推奨
    // 仮：成功したら即反映
    await _setPremium(true);
  }

  Future<ProductDetails> _getProductDetails() async {
    final response = await InAppPurchase.instance.queryProductDetails({_productId});
    if (response.notFoundIDs.isNotEmpty) throw Exception('Product not found');
    return response.productDetails.first;
  }

  Future<void> _setPremium(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_subscriptionKey, value);
    isSubscribedNotifier.value = value; // ← ここが超重要！
  }

  Future<void> refreshSubscriptionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool(_subscriptionKey) ?? false;
    isSubscribedNotifier.value = value;
  }
}
