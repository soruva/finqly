import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionManager {
  static const _subscriptionKey = 'isSubscribed';
  static const _productId = 'finqly_plus_subscription'; // ← Play Consoleで設定したID
  bool isSubscribed = false;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    isSubscribed = prefs.getBool(_subscriptionKey) ?? false;
    // 起動時にGoogleの購読状況もチェック（本番用API呼び出しは省略例）
    // await refreshSubscriptionStatus(); // ←課金サーバーも参照するなら有効化
  }

  Future<bool> checkSubscription() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_subscriptionKey) ?? false;
  }

  Future<void> buyPremium() async {
    final available = await InAppPurchase.instance.isAvailable();
    if (!available) throw Exception('In-app purchases not available');

    final purchaseParam = PurchaseParam(productDetails: await _getProductDetails());
    final result = await InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);

    // ここで実購入フロー後の判定
    // 簡易ロジック: 購入履歴などを購読
    // 本番では「purchaseUpdatedStream」などで検証が必要

    // 仮に成功とする場合（本番はトークン検証など実装）
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
    isSubscribed = value;
  }

  Future<void> refreshSubscriptionStatus() async {
    // 本番では「Google課金サーバー」or「ローカル（SharedPreferences）」両方で判定推奨
    final prefs = await SharedPreferences.getInstance();
    isSubscribed = prefs.getBool(_subscriptionKey) ?? false;
  }
}
