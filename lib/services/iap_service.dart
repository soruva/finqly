// /workspaces/finqly/lib/services/iap_service.dart
import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';

class IapService {
  IapService._();
  static final IapService instance = IapService._();

  final InAppPurchase _iap = InAppPurchase.instance;

  static const String kSubPremium = 'finqly_premium';
  static const String kOneTimeDiagnosis = 'inapp_one_time_diagnosis';
  static const String kBundleStarter = 'starter_bundle';

  final List<ProductDetails> _products = [];
  bool _available = false;

  Stream<List<PurchaseDetails>> get purchaseStream => _iap.purchaseStream;

  Future<void> init() async {
    _available = await _iap.isAvailable();
    if (!_available) return;

    const ids = <String>{kSubPremium, kOneTimeDiagnosis, kBundleStarter};
    final resp = await _iap.queryProductDetails(ids);
    _products
      ..clear()
      ..addAll(resp.productDetails);
  }

  ProductDetails? _find(String id) {
    try { return _products.firstWhere((p) => p.id == id); } catch (_) { return null; }
  }

  String priceForSubscription({required bool yearly}) {
    final pd = _find(kSubPremium);
    return pd?.price ?? '';
  }

  Future<void> buySubscription({required bool yearly}) async {
    final pd = _find(kSubPremium);
    if (pd == null) return;
    final param = PurchaseParam(productDetails: pd);
    await _iap.buyNonConsumable(purchaseParam: param);
  }

  Future<void> buyOneTime(String productId) async {
    final pd = _find(productId);
    if (pd == null) return;
    final param = PurchaseParam(productDetails: pd);
    if (productId == kOneTimeDiagnosis) {
      await _iap.buyConsumable(purchaseParam: param, autoConsume: true);
    } else {
      await _iap.buyNonConsumable(purchaseParam: param);
    }
  }

  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  bool get isStoreAvailable => _available;
  List<ProductDetails> get allProducts => List.unmodifiable(_products);
}
