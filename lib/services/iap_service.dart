import 'dart:async';
import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

class IapService {
  static const String subscriptionId      = 'finqly_premium';
  static const String oneTimeDiagnosisId  = 'inapp_one_time_diagnosis';
  static const String starterBundleId     = 'starter_bundle';

  static const String monthlyBasePlanId   = 'monthly-auto-basic';
  static const String yearlyBasePlanId    = 'yearly-autobasic';

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

      await _purchaseSub?.cancel();
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

      // try restore once on init
      await _iap.restorePurchases();
    } catch (e) {
      onError(e);
    }
  }

  void dispose() => _purchaseSub?.cancel();

  ProductDetails? _get(String id) {
    try { return _products.firstWhere((e) => e.id == id); }
    catch (_) { return null; }
  }

  bool hasBasePlan(String productId, String basePlanId) {
    final pd = _get(productId);
    if (!(Platform.isAndroid && pd is GooglePlayProductDetails)) return false;
    final offers = pd.subscriptionOfferDetails ?? const <SubscriptionOfferDetails>[];
    return offers.any((o) => o.basePlanId == basePlanId);
  }

  Future<void> buySubscription({required bool yearly}) async {
    final pd = _get(subscriptionId);
    if (pd == null) {
      throw 'Subscription product not found';
    }

    if (Platform.isAndroid && pd is GooglePlayProductDetails) {
      final targetBasePlanId = yearly ? yearlyBasePlanId : monthlyBasePlanId;
      final offers = pd.subscriptionOfferDetails ?? const <SubscriptionOfferDetails>[];
      final offer = offers.firstWhere(
        (o) => o.basePlanId == targetBasePlanId,
        orElse: () => throw 'Offer for "$targetBasePlanId" not found. Check Play Console.',
      );

      final param = GooglePlayPurchaseParam(
        productDetails: pd,
        subscriptionOfferDetails: offer,
      );
      await _iap.buyNonConsumable(purchaseParam: param);
      return;
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

  String priceForSubscription({required bool yearly}) {
    final pd = _get(subscriptionId);
    if (pd == null) return yearly ? '\$99.99 / year' : '\$9.99 / month';

    if (Platform.isAndroid && pd is GooglePlayProductDetails) {
      final basePlanId = yearly ? yearlyBasePlanId : monthlyBasePlanId;
      final offer = (pd.subscriptionOfferDetails ?? const <SubscriptionOfferDetails>[])
          .firstWhere((o) => o.basePlanId == basePlanId, orElse: () => null);

      final phases = offer?.pricingPhases.pricingPhaseList;
      if (phases != null && phases.isNotEmpty) {
        final wanted = yearly ? 'P1Y' : 'P1M';
        final phase = phases.firstWhere(
          (ph) => ph.billingPeriod == wanted,
          orElse: () => phases.last,
        );
        final micros = phase.priceAmountMicros;
        final code = phase.priceCurrencyCode;
        if (micros != null && code != null) {
          final amount = micros / 1e6;
          final numStr = amount.toStringAsFixed(amount.truncateToDouble() == amount ? 0 : 2);
          final priceStr = code == 'USD' ? '\$$numStr' : '$numStr $code';
          return yearly ? '$priceStr / year' : '$priceStr / month';
        }
      }
    }

    final base = pd.price.isNotEmpty ? pd.price : (yearly ? '\$99.99' : '\$9.99');
    return yearly ? '$base / year' : '$base / month';
  }
}
