// lib/services/iap_service.dart
import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:flutter/foundation.dart';

typedef IapVerifiedCallback = void Function(PurchaseDetails purchase);
typedef IapErrorCallback = void Function(Object error, [StackTrace? stack]);

class IapService {
  IapService._internal();
  static final IapService instance = IapService._internal();

  factory IapService({IapVerifiedCallback? onVerified, IapErrorCallback? onError}) {
    if (onVerified != null) instance._onVerified = onVerified;
    if (onError != null) instance._onError = onError;
    instance._ensureInit();
    return instance;
  }

  static const String subscriptionId     = 'finqly_premium';
  static const String oneTimeDiagnosisId = 'inapp_one_time_diagnosis';
  static const String starterBundleId    = 'starter_bundle';

  final InAppPurchase _iap = InAppPurchase.instance;
  final List<ProductDetails> _products = [];
  bool _available = false;
  bool _inited = false;

  bool _entitlementActive = false;

  final ValueNotifier<bool> subscriptionSkuAvailable = ValueNotifier(false);

  IapVerifiedCallback? _onVerified;
  IapErrorCallback? _onError;

  StreamSubscription<List<PurchaseDetails>>? _purchaseSub;

  bool get isAvailable => _available;
  bool get hasSubscriptionSku => subscriptionSkuAvailable.value;
  List<ProductDetails> get products => List.unmodifiable(_products);

  Stream<List<PurchaseDetails>> get purchaseStream => _iap.purchaseStream;

  void setCallbacks({IapVerifiedCallback? onVerified, IapErrorCallback? onError}) {
    if (onVerified != null) _onVerified = onVerified;
    if (onError != null) _onError = onError;
  }

  Future<void> init() async {
    if (_inited) return;
    _inited = true;

    _available = await _iap.isAvailable();
    if (!_available) return;

    const ids = <String>{subscriptionId, oneTimeDiagnosisId, starterBundleId};
    final resp = await _iap.queryProductDetails(ids);

    _products
      ..clear()
      ..addAll(resp.productDetails);

    subscriptionSkuAvailable.value = _products.any((p) => p.id == subscriptionId);

    _purchaseSub ??= purchaseStream.listen((purchases) async {
      for (final p in purchases) {
        try {
          if (p.productID == subscriptionId) {
            switch (p.status) {
              case PurchaseStatus.purchased:
              case PurchaseStatus.restored:
                _entitlementActive = true;
                break;
              case PurchaseStatus.canceled:
              case PurchaseStatus.error:
                break;
              case PurchaseStatus.pending:
                break;
            }
          }

          switch (p.status) {
            case PurchaseStatus.purchased:
            case PurchaseStatus.restored:
              _onVerified?.call(p);
              break;
            case PurchaseStatus.error:
              _onError?.call(p.error ?? 'purchase_error');
              break;
            case PurchaseStatus.pending:
            case PurchaseStatus.canceled:
              break;
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

  void _ensureInit() {
    // ignore: discarded_futures
    init();
  }

  ProductDetails? _find(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  String priceForSubscription() {
    final pd = _find(subscriptionId);
    return pd?.price ?? '';
  }

  String priceFor(String productId, {String fallback = ''}) {
    final pd = _find(productId);
    return (pd?.price ?? '').isNotEmpty ? (pd!.price) : fallback;
  }

  // ===== Purchasing =====
  Future<void> buySubscription({required bool yearly}) async {
    if (!_available) return;
    if (!hasSubscriptionSku) {
      throw StateError('Subscription not available in this region');
    }
    final pd = _find(subscriptionId);
    if (pd == null) throw StateError('Subscription product not found');
    final param = PurchaseParam(productDetails: pd);
    await _iap.buyNonConsumable(purchaseParam: param);
  }

  Future<void> buyOneTime(String productId) async {
    if (!_available) return;
    final pd = _find(productId);
    if (pd == null) throw StateError('Product $productId not found');

    final isConsumable = productId == oneTimeDiagnosisId;
    final param = PurchaseParam(productDetails: pd);

    if (isConsumable) {
      await _iap.buyConsumable(purchaseParam: param, autoConsume: true);
    } else {
      await _iap.buyNonConsumable(purchaseParam: param);
    }
  }

  Future<bool> restorePurchases() async {
    if (!_available) return false;
    try {
      await _iap.restorePurchases();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> hasActiveSubscription() async {
    return _entitlementActive;
  }

  void dispose() {
    _purchaseSub?.cancel();
    _purchaseSub = null;
  }
}
