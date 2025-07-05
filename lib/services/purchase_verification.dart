import 'package:in_app_purchase/in_app_purchase.dart';

class PurchaseVerification {
  // 本番：Google Play Billing APIで検証
  static Future<bool> verifyPurchase(PurchaseDetails purchase) async {
    // Google審査の場合はpurchase.verificationDataを使う
    // サーバー検証も追加可能（ここでは簡易チェック）
    return purchase.status == PurchaseStatus.purchased;
  }
}
