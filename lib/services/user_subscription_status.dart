import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSubscriptionStatus {
  static const String _key = 'isPremiumUser';
  static const String _productId = 'finqly_plus_subscription';

  // ストリームで購入/復元時に呼ぶ
  Future<void> setPremium(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
    print('[Subscription] Premium set to: $value');
  }

  // 課金状態チェック
  Future<bool> isPremium() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  // Google Playの購入復元API
  Future<void> restoreAndSyncPremium() async {
    await InAppPurchase.instance.restorePurchases();
    // 実際の「判定・保存」は purchaseStream で!
  }

  // --- 購入/復元イベント監視: これをmain.dart/initStateなどで呼ぶ ---
  static void listenToPurchaseUpdates() {
    InAppPurchase.instance.purchaseStream.listen((List<PurchaseDetails> purchases) async {
      for (final purchase in purchases) {
        if (purchase.productID == _productId &&
            (purchase.status == PurchaseStatus.purchased || purchase.status == PurchaseStatus.restored)) {
          await UserSubscriptionStatus().setPremium(true);
        } else if (purchase.productID == _productId && purchase.status == PurchaseStatus.canceled) {
          await UserSubscriptionStatus().setPremium(false);
        }
      }
    });
  }
}
