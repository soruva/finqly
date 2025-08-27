import 'package:in_app_purchase/in_app_purchase.dart';

/// TEMP: Client-side verification for internal testing & review.
/// TODO: Replace with server-side verification using Play Developer API.
class PurchaseVerification {
  /// Accepts purchased/restored locally. Replace with real server check later.
  static Future<bool> verify(PurchaseDetails p) async {
    return p.status == PurchaseStatus.purchased ||
           p.status == PurchaseStatus.restored;
  }

  /// Extract token you will send to your backend later.
  /// - Android: purchaseToken (string)
  /// - iOS: base64 receipt (string)
  static String? token(PurchaseDetails p) {
    final data = p.verificationData.serverVerificationData;
    return data.isEmpty ? null : data;
  }
}

