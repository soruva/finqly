import 'package:in_app_purchase/in_app_purchase.dart';

class UserSubscriptionStatus {
  static const String _productId = 'finqly_plus_subscription'; // ご自身のProduct ID

  Future<bool> isPremium() async {
    final bool available = await InAppPurchase.instance.isAvailable();
    if (!available) return false;

    // 購入履歴取得
    final QueryPurchaseDetailsResponse response =
        await InAppPurchase.instance.queryPastPurchases();

    if (response.error != null) {
      // エラーがあれば課金扱いしない
      return false;
    }

    for (final PurchaseDetails purchase in response.pastPurchases) {
      // productID または productId どちらかバージョンで確認（両対応）
      final id = purchase.productID ?? purchase.productId;
      if ((id == _productId) &&
          (purchase.status == PurchaseStatus.purchased ||
           purchase.status == PurchaseStatus.restored)) {
        return true;
      }
    }
    return false;
  }
}
