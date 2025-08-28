// /workspaces/finqly/lib/screens/premium_plans_page.dart
import 'package:flutter/material.dart';
import 'package:finqly/services/subscription_manager.dart';
import 'package:finqly/services/iap_service.dart';

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
    try {
      await _iap.init();
    } catch (e) {
      _error = e.toString();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _iap.dispose();
    super.dispose();
  }

  String _monthlyPrice() => '\$9.99 / month';
  String _yearlyPrice() => '\$99.99 / year';
  String _oneTimeDiagnosisPrice() => '\$2.99 / time';
  String _starterBundlePrice() => '\$19.99 (one time)';

  Future<void> _handlePurchase(Future<bool> Function() action) async {
    if (_isPurchasing) return;
    setState(() {
      _isPurchasing = true;
      _error = null;
    });
    try {
      final ok = await action();
      if (!mounted) return;
      if (ok) {
        await widget.subscriptionManager.setSubscribed(true);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Purchase completed')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Purchase failed')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Purchase error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isPurchasing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'title': 'Monthly Plan',
        'price': _monthlyPrice(),
        'desc': 'Unlock all premium features with a monthly subscription.',
        'onPressed': () => _handlePurchase(() => _iap.buySubscription(yearly: false)),
      },
      {
        'title': 'Annual Plan',
        'price': _yearlyPrice(),
        'desc': 'Save more! Yearly subscription, all premium features.',
        'onPressed': () => _handlePurchase(() => _iap.buySubscription(yearly: true)),
      },
      {
        'title': 'One-time Diagnosis',
        'price': _oneTimeDiagnosisPrice(),
        'desc': 'Premium diagnosis one time only, no subscription needed.',
        'onPressed': () => _handlePurchase(() => _iap.buyOneTime(IapService.oneTimeDiagnosisId)),
      },
      {
        'title': 'Starter Bundle',
        'price': _starterBundlePrice(),
        'desc': 'Pack: Diagnosis, Forecast & Education tips. Lifetime access.',
        'onPressed': () => _handlePurchase(() => _iap.buyOneTime(IapService.starterBundleId)),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your Premium Plan'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          if (_loading) const LinearProgressIndicator(minHeight: 2),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text('Error: $_error', style: const TextStyle(color: Colors.red)),
            ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 24),
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
                        Text(
                          plan['title'] as String,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
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
                              onPressed: (_loading || _isPurchasing)
                                  ? null
                                  : plan['onPressed'] as VoidCallback,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                              ),
                              child: _isPurchasing
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                    )
                                  : const Text('Select', style: TextStyle(fontSize: 16)),
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
