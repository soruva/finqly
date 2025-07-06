import 'package:in_app_purchase/in_app_purchase.dart';

class UserSubscriptionStatus {
  static const String _productId = 'finqly_plus_subscription';

  Future<bool> isPremium() async {
    final available = await InAppPurchase.instance.isAvailable();
    if (!available) return false;

    final response = await InAppPurchase.instance.queryPastPurchases();
    for (final purchase in response.pastPurchases) {
      if (purchase.productID == _productId &&
          (purchase.status == PurchaseStatus.purchased ||
           purchase.status == PurchaseStatus.restored)) {
        return true;
      }
    }
    return false;
  }
}
