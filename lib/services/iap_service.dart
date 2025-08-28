// /workspaces/finqly/lib/services/iap_service.dart
import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';

typedef IapVerifiedCallback = void Function(PurchaseDetails purchase);
typedef IapErrorCallback = void Function(Object error, [StackTrace? stack]);

class IapService {
  // ---- Singleton ----
  IapService._internal();
  static final IapService instance = IapService._internal();

  factory IapService({IapVerifiedCallback? onVerified, IapErrorCallback? onError}) {
    if (onVerified != null) instance._onVerified = onVerified;
    if (onError != null) instance._onError = onError;
    return instance;
  }

  // ---- IDs ----
  static const String subscriptionId = 'finqly_premium';
  static const String oneTimeDiagnosisId = 'inapp_one_time_diagnosis';
  static const String starterBundleId = 'starter_bundle';

  // ---- Internals ----
  final InAppPurchase _iap = InAppPurchase.instance;
  final List<ProductDetails> _products = [];
  bool _available = false;

  // Optional callbacks (for legacy screens)
  IapVerifiedCallback? _onVerified;
  IapErrorCallback? _onError;

  StreamSubscription<List<PurchaseDetails>>? _purchaseSub;

  // ---- Public API (legacy-friendly) ----
  bool get isAvailable => _available;
  List<ProductDetails> get products => List.unmodifiable(_products);
  Stream<List<PurchaseDetails>> get purchaseStream => _iap.purchaseStream;

  Future<void> init() async {
    _available = await _iap.isAvailable();
    if (!_available) return;

    const ids = <String>{subscriptionId, oneTimeDiagnosisId, starterBundleId};
    final resp = await _iap.queryProductDetails(ids);
    _products
      ..clear()
      ..addAll(resp.productDetails);

    _purchaseSub ??= purchaseStream.listen((purchases) async {
      for (final p in purchases) {
        try {
          if (p.status == PurchaseStatus.purchased || p.status == PurchaseStatus.restored) {
            _onVerified?.call(p);
          } else if (p.status == PurchaseStatus.error) {
            _onError?.call(p.error ?? 'purchase_error');
          }
          if (p.pendingCompletePurchase) {
            await _iap.completePurchase(p);
          }
        } catch (e, st) {
          _onError?.call(e, st);
        }
      }
    });
  }

  ProductDetails? _find(String id) {
    try { return _products.firstWhere((p) => p.id == id); } catch (_) { return null; }
  }

  String priceForSubscription({required bool yearly}) {
    final pd = _find(subscriptionId);
    return pd?.price ?? '';
  }

  Future<void> buySubscription({required bool yearly}) async {
    final pd = _find(subscriptionId);
    if (pd == null) return;
    final param = PurchaseParam(productDetails: pd);
    await _iap.buyNonConsumable(purchaseParam: param);
  }

  Future<void> buyOneTime(String productId) async {
    final pd = _find(productId);
    if (pd == null) return;
    final param = PurchaseParam(productDetails: pd);
    if (productId == oneTimeDiagnosisId) {
      await _iap.buyConsumable(purchaseParam: param, autoConsume: true);
    } else {
      await _iap.buyNonConsumable(purchaseParam: param);
    }
  }

  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  void dispose() {
    _purchaseSub?.cancel();
    _purchaseSub = null;
  }
}
