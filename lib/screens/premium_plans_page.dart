import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:finqly/services/iap_service.dart';
import 'package:finqly/services/subscription_manager.dart';

class PremiumPlansPage extends StatefulWidget {
  final SubscriptionManager subscriptionManager;
  const PremiumPlansPage({super.key, required this.subscriptionManager});

  @override
  State<PremiumPlansPage> createState() => _PremiumPlansPageState();
}

class _PremiumPlansPageState extends State<PremiumPlansPage> {
  late final IapService _iap;

  bool _loading = true;
  bool _isPurchasing = false;
  String? _error;

  bool _subsProductMissing = false;

  @override
  void initState() {
    super.initState();
    _iap = IapService(); // = IapService.instance
    _initIap();
  }

  Future<void> _initIap() async {
    setState(() {
      _loading = true;
      _error = null;
      _subsProductMissing = false;
    });
    try {
      await _iap.init();

      final hasSubs = _pd(IapService.subscriptionId) != null;
      if (!mounted) return;
      setState(() {
        _subsProductMissing = !hasSubs;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
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
    final base = pd.price.isNotEmpty ? pd.price : (yearly ? '\$99.99' : '\$9.99');
    return yearly ? '$base / year' : '$base / month';
  }

  String _inappPrice(String id, String fallback) {
    final pd = _pd(id);
    return (pd != null && pd.price.isNotEmpty) ? pd.price : fallback;
  }

  Future<void> _handleAction(Future<void> Function() action) async {
    if (_isPurchasing) return;

    final messenger = ScaffoldMessenger.of(context);

    setState(() {
      _isPurchasing = true;
      _error = null;
    });

    try {
      await action();
      if (!mounted) return;

      await widget.subscriptionManager.setSubscribed(true);
      if (!mounted) return;

      messenger.showSnackBar(const SnackBar(content: Text('Purchase completed')));
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
      messenger.showSnackBar(SnackBar(content: Text('Purchase error: $e')));
    } finally {
      if (mounted) setState(() => _isPurchasing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final subsPdExists = _pd(IapService.subscriptionId) != null;
    final canPurchase = _iap.isAvailable && !_isPurchasing;

    final items = [
      {
        'key': 'monthly',
        'title': 'Monthly Plan',
        'price': _subPrice(yearly: false),
        'desc': 'Unlock all premium features with a monthly subscription.',
        'onPressed': () => _handleAction(() => _iap.buySubscription(yearly: false)),
        'requiresSubsProduct': true,
      },
      {
        'key': 'annual',
        'title': 'Annual Plan',
        'price': _subPrice(yearly: true),
        'desc': 'Save more! Yearly subscription, all premium features.',
        'onPressed': () => _handleAction(() => _iap.buySubscription(yearly: true)),
        'requiresSubsProduct': true,
      },
      {
        'key': 'one_time',
        'title': 'One-time Diagnosis',
        'price': '${_inappPrice(IapService.oneTimeDiagnosisId, '\$2.99')} / time',
        'desc': 'Premium diagnosis one time only, no subscription needed.',
        'onPressed': () => _handleAction(() => _iap.buyOneTime(IapService.oneTimeDiagnosisId)),
        'requiresSubsProduct': false,
      },
      {
        'key': 'bundle',
        'title': 'Starter Bundle',
        'price': '${_inappPrice(IapService.starterBundleId, '\$19.99')} (one time)',
        'desc': 'Pack: Diagnosis, Forecast & Education tips. Lifetime access.',
        'onPressed': () => _handleAction(() => _iap.buyOneTime(IapService.starterBundleId)),
        'requiresSubsProduct': false,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your Premium Plan'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _loading ? null : _initIap,
            tooltip: 'Reload',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_loading) const LinearProgressIndicator(minHeight: 2),

          if (!_iap.isAvailable && !_loading)
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: Text(
                'Play Store not available. Please sign in to Google Play and try again.',
                style: TextStyle(color: Colors.orange, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),

          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text('Error: $_error', style: const TextStyle(color: Colors.red)),
            ),

          if (_subsProductMissing || !subsPdExists)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Card(
                color: const Color(0xFFFFF3E0),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: const Padding(
                  padding: EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Subscriptions are not available yet.',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Please check your Play Console subscription settings:\n'
                        '• Subscription productId matches the app code (IapService.subscriptionId)\n'
                        '• Base plan (Monthly/Yearly) is ACTIVE\n'
                        '• “Available to new subscribers” is ON\n'
                        '• Pricing (incl. JPY) is set & Countries include Japan\n'
                        '• Your Google account is a tester and has opted-in',
                        style: TextStyle(fontSize: 12, color: Colors.black87, height: 1.3),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 24),
              itemBuilder: (context, idx) {
                final plan = items[idx];
                final requiresSubs = plan['requiresSubsProduct'] as bool;
                final isSubsMissing = requiresSubs && !subsPdExists;

                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              plan['title'] as String,
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                            ),
                            if (requiresSubs)
                              Chip(
                                label: Text(
                                  subsPdExists ? 'Available' : 'Not ready',
                                  style: TextStyle(
                                    color: subsPdExists ? Colors.white : Colors.black87,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                backgroundColor:
                                    subsPdExists ? Colors.green : const Color(0xFFFFE082),
                                visualDensity: VisualDensity.compact,
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(plan['desc'] as String, style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              plan['price'] as String,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            ElevatedButton(
                              onPressed: (canPurchase && !isSubsMissing)
                                  ? plan['onPressed'] as VoidCallback
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                              ),
                              child: _isPurchasing
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2, color: Colors.white),
                                    )
                                  : const Text('Select', style: TextStyle(fontSize: 16)),
                            ),
                          ],
                        ),
                        if (isSubsMissing)
                          const Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              'Subscription product is not available in this build/region/account.',
                              style: TextStyle(fontSize: 12, color: Colors.redAccent),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
            child: Text(
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
