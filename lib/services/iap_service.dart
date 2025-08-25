import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';

class IapService {
  static const String subscriptionId = 'finqly_premium';
  static const String oneTimeDiagnosisId = 'inapp_one_time_diagnosis';
  static const String starterBundleId   = 'starter_bundle';

  final _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSub;

  bool _available = false;
  List<ProductDetails> _products = [];

  bool get isAvailable => _available;
  List<ProductDetails> get products => _products;

  Future<void> init({
    required Future<void> Function(PurchaseDetails p) onVerified,
    required void Function(Object e) onError,
  }) async {
    try {
      _available = await _iap.isAvailable();
      if (!_available) return;

      final resp = await _iap.queryProductDetails({
        subscriptionId,
        oneTimeDiagnosisId,
        starterBundleId,
      });

      if (resp.error != null) onError(resp.error!);
      _products = resp.productDetails;

      _purchaseSub?.cancel();
      _purchaseSub = _iap.purchaseStream.listen((purchases) async {
        for (final p in purchases) {
          try {
            switch (p.status) {
              case PurchaseStatus.purchased:
              case PurchaseStatus.restored:
                await onVerified(p);
                if (p.pendingCompletePurchase) {
                  await _iap.completePurchase(p);
                }
                break;
              case PurchaseStatus.error:
                onError(p.error ?? 'Unknown IAP error');
                break;
              case PurchaseStatus.canceled:
              case PurchaseStatus.pending:
                break;
            }
          } catch (e) {
            onError(e);
          }
        }
      }, onError: onError);
    } catch (e) {
      onError(e);
    }
  }

  void dispose() => _purchaseSub?.cancel();

  ProductDetails? _get(String id) {
    try {
      return _products.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> buySubscription({required bool yearly}) async {
    final pd = _get(subscriptionId);
    if (pd == null) {
      throw 'Subscription product not found';
    }
    final param = PurchaseParam(productDetails: pd);
    await _iap.buyNonConsumable(purchaseParam: param);
  }

  Future<void> buyOneTime(String productId) async {
    final pd = _get(productId);
    if (pd == null) throw 'Product not found: $productId';
    final param = PurchaseParam(productDetails: pd);
    await _iap.buyNonConsumable(purchaseParam: param);
  }
}
