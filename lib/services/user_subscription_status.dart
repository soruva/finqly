import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSubscriptionStatus {
  static const String _key = 'isPremiumUser';
  static const String _productId = 'finqly_plus_subscription';

  Future<void> setPremium(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
    // WARNING: Local-only status. For production, must validate with Google Play server.
  }

  Future<bool> isPremium() async {
    final prefs = await SharedPreferences.getInstance();
    // WARNING: Only returns local value! Must implement server verification for real security.
    return prefs.getBool(_key) ?? false;
  }

  Future<void> restoreAndSyncPremium() async {
    await InAppPurchase.instance.restorePurchases();
    // TODO: Properly handle restored purchases using server-side receipt validation.
  }

  static void listenToPurchaseUpdates() {
    InAppPurchase.instance.purchaseStream.listen((List<PurchaseDetails> purchases) async {
      for (final purchase in purchases) {
        if (purchase.productID == _productId &&
            (purchase.status == PurchaseStatus.purchased || purchase.status == PurchaseStatus.restored)) {
          // TODO: In production, validate purchaseToken on server before unlocking premium features.
          await UserSubscriptionStatus().setPremium(true);
        } else if (purchase.productID == _productId && purchase.status == PurchaseStatus.canceled) {
          await UserSubscriptionStatus().setPremium(false);
        }
      }
    });
  }
}
