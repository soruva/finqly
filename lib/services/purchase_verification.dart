class PurchaseVerification {
  static bool verifyPurchase(String purchaseToken) {
    // 本番ではGoogle PlayのAPI連携などに置き換え
    return purchaseToken.isNotEmpty;
  }
}
