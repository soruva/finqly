// lib/services/iap_service.dart
import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

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

  static const String subscriptionId = 'finqly_premium';

  static const String monthlyBasePlanId = 'monthly-auto-basic';
  static const String yearlyBasePlanId  = 'yearly-autobasic';

  static const String oneTimeDiagnosisId = 'inapp_one_time_diagnosis';
  static const String starterBundleId    = 'starter_bundle';

  final InAppPurchase _iap = InAppPurchase.instance;
  final List<ProductDetails> _products = [];
  bool _available = false;
  bool _inited = false;

  IapVerifiedCallback? _onVerified;
  IapErrorCallback? _onError;

  StreamSubscription<List<PurchaseDetails>>? _purchaseSub;

  bool get isAvailable => _available;
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

    const ids = <String>{
      subscriptionId,
      oneTimeDiagnosisId,
      starterBundleId,
    };

    final resp = await _iap.queryProductDetails(ids);
    _products
      ..clear()
      ..addAll(resp.productDetails);

    _purchaseSub ??= purchaseStream.listen((purchases) async {
      for (final p in purchases) {
        try {
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

  SubscriptionOfferDetails? _pickOffer({
    required bool yearly,
  }) {
    final sub = _find(subscriptionId);
    final offers = sub?.subscriptionOfferDetails;
    if (offers == null || offers.isEmpty) return null;

    final wantedBasePlanId = yearly ? yearlyBasePlanId : monthlyBasePlanId;

    final matched = offers.where((o) => o.basePlanId == wantedBasePlanId);
    if (matched.isNotEmpty) return matched.first;

    return offers.first;
  }

  String priceForSubscription({required bool yearly}) {
    final offer = _pickOffer(yearly: yearly);
    final phases = offer?.pricingPhases.pricingPhaseList;
    if (phases != null && phases.isNotEmpty) {
      return phases.first.formattedPrice;
    }
    return yearly ? '\$99.99 / year' : '\$9.99 / month';
  }

  Future<void> buySubscription({required bool yearly}) async {
    if (!_available) return;

    final sub = _find(subscriptionId);
    final offer = _pickOffer(yearly: yearly);
    if (sub == null || offer == null) return;

    final param = GooglePlayPurchaseParam(
      productDetails: sub,
      offerToken: offer.offerToken,
    );

    await _iap.buyNonConsumable(purchaseParam: param);
  }

  Future<void> buyOneTime(String productId) async {
    if (!_available) return;
    final pd = _find(productId);
    if (pd == null) return;

    final isConsumable = productId == oneTimeDiagnosisId;
    final param = PurchaseParam(productDetails: pd);

    if (isConsumable) {
      await _iap.buyConsumable(purchaseParam: param, autoConsume: true);
    } else {
      await _iap.buyNonConsumable(purchaseParam: param);
    }
  }

  Future<void> restorePurchases() async {
    if (!_available) return;
    await _iap.restorePurchases();
  }

  void dispose() {
    _purchaseSub?.cancel();
    _purchaseSub = null;
  }
}
