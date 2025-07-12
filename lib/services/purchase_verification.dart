import 'package:in_app_purchase/in_app_purchase.dart';

class PurchaseVerification {
  static Future<bool> verifyPurchase(PurchaseDetails purchase) async {
    return purchase.status == PurchaseStatus.purchased;
  }
}
