import 'package:flutter/material.dart';
import 'package:finqly/services/subscription_manager.dart';

class PremiumPlansPage extends StatelessWidget {
  final SubscriptionManager subscriptionManager;
  const PremiumPlansPage({super.key, required this.subscriptionManager});

  @override
  Widget build(BuildContext context) {
    // TODO: For production, connect each plan to Google Play Billing API.
    // WARNING: Currently, selecting a plan only sets a local flag.
    // Real purchase must be processed and validated through Google Play.
    // Display terms: Subscriptions auto-renew unless canceled. You can cancel anytime from your Google Play account.

    final plans = [
      {
        'title': 'Monthly Plan',
        'price': '\$9.99 / month',
        'desc': 'Unlock all premium features with a monthly subscription.',
        'onPressed': () async {
          await subscriptionManager.setSubscribed(true);
          if (context.mounted) Navigator.pop(context, true);
        }
      },
      {
        'title': 'Annual Plan',
        'price': '\$99.99 / year',
        'desc': 'Save more! Yearly subscription, all premium features.',
        'onPressed': () async {
          await subscriptionManager.setSubscribed(true);
          if (context.mounted) Navigator.pop(context, true);
        }
      },
      {
        'title': 'One-time Diagnosis',
        'price': '\$2.99 / time',
        'desc': 'Premium diagnosis one time only, no subscription needed.',
        'onPressed': () async {
          await subscriptionManager.setSubscribed(true);
          if (context.mounted) Navigator.pop(context, true);
        }
      },
      {
        'title': 'Starter Bundle',
        'price': '\$19.99 (one time)',
        'desc': 'Pack: Diagnosis, Forecast & Education tips. Lifetime access.',
        'onPressed': () async {
          await subscriptionManager.setSubscribed(true);
          if (context.mounted) Navigator.pop(context, true);
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
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: plans.length,
              separatorBuilder: (_, __) => const SizedBox(height: 24),
              itemBuilder: (context, idx) {
                final plan = plans[idx];
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(plan['title'] as String, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 10),
                        Text(plan['desc'] as String, style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(plan['price'] as String, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ElevatedButton(
                              onPressed: plan['onPressed'] as VoidCallback,
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
            child: Text(
              "Subscriptions auto-renew unless canceled. You can cancel anytime from your Google Play account. All payments are processed securely via Google Play Billing.",
              style
