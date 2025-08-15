import 'package:flutter/material.dart';
import 'package:finqly/services/subscription_manager.dart';
import 'package:finqly/services/iap_service.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PremiumPlansPage extends StatefulWidget {
  final SubscriptionManager subscriptionManager;
  const PremiumPlansPage({super.key, required this.subscriptionManager});

  @override
  State<PremiumPlansPage> createState() => _PremiumPlansPageState();
}

class _PremiumPlansPageState extends State<PremiumPlansPage> {
  late final IapService _iap;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _iap = IapService();
    _initIap();
  }

  Future<void> _initIap() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    await _iap.init(
      onVerified: (p) async {
        await widget.subscriptionManager.setSubscribed(true);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Purchase completed')),
          );
        }
      },
      onError: (e) {
        setState(() => _error = e.toString());
      },
    );
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    _iap.dispose();
    super.dispose();
  }

  ProductDetails? _pd(String id) {
    try {
      return _iap.products.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  String _subPrice({required bool yearly}) {
    final pd = _pd(IapService.subscriptionId);
    if (pd == null) return yearly ? '\$99.99 / year' : '\$9.99 / month';

    final offers = pd.googlePlayProductDetails?.subscriptionOfferDetails ?? [];
    for (final offer in offers) {
      for (final phase in offer.pricingPhases.pricingPhaseList) {
        if (phase.billingPeriod == (yearly ? 'P1Y' : 'P1M')) {
          final micros = phase.priceAmountMicros;
          final currency = phase.priceCurrencyCode;
          if (micros != null && currency != null) {
            final v = (micros / 1000000.0);
            final isUsd = currency == 'USD';
            final numStr = v.toStringAsFixed(v.truncateToDouble() == v ? 0 : 2);
            final priceStr = isUsd ? '\$$numStr' : '$numStr $currency';
            return yearly ? '$priceStr / year' : '$priceStr / month';
          }
        }
      }
    }
    return yearly ? '\$99.99 / year' : '\$9.99 / month';
  }

  String _inappPrice(String id, String fallback) {
    final pd = _pd(id);
    if (pd == null) return fallback; // 例: $2.99 / time
    return pd.price;
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'title': 'Monthly Plan',
        'price': _subPrice(yearly: false),
        'desc': 'Unlock all premium features with a monthly subscription.',
        'onPressed': () async {
          await _iap.buySubscription(yearly: false);
        }
      },
      {
        'title': 'Annual Plan',
        'price': _subPrice(yearly: true),
        'desc': 'Save more! Yearly subscription, all premium features.',
        'onPressed': () async {
          await _iap.buySubscription(yearly: true);
        }
      },
      {
        'title': 'One-time Diagnosis',
        'price': '${_inappPrice(IapService.oneTimeDiagnosisId, '\$2.99')} / time',
        'desc': 'Premium diagnosis one time only, no subscription needed.',
        'onPressed': () async {
          await _iap.buyOneTime(IapService.oneTimeDiagnosisId);
        }
      },
      {
        'title': 'Starter Bundle',
        'price': '${_inappPrice(IapService.starterBundleId, '\$19.99')} (one time)',
        'desc': 'Pack: Diagnosis, Forecast & Education tips. Lifetime access.',
        'onPressed': () async {
          await _iap.buyOneTime(IapService.starterBundleId);
        }
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your Premium Plan'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          if (_loading)
            const LinearProgressIndicator(minHeight: 2),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text('Error: $_error', style: const TextStyle(color: Colors.red)),
            ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 24),
              itemBuilder: (context, idx) {
                final plan = items[idx];
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(plan['title'] as String,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 10),
                        Text(plan['desc'] as String, style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(plan['price'] as String,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ElevatedButton(
                              onPressed: _iap.isAvailable
                                  ? plan['onPressed'] as VoidCallback
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                              ),
                              child: const Text('Select', style: TextStyle(fontSize: 16)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Terms and important notice for Google Play review:
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
            child: const Text(
              'Subscriptions auto-renew unless canceled. You can cancel anytime from your Google Play account. '
              'All payments are processed securely via Google Play Billing.',
              style: TextStyle(fontSize: 12, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
