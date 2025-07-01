import 'package:flutter/material.dart';
import 'package:finqly/services/subscription_manager.dart';
import 'package:finqly/l10n/generated/app_localizations.dart';

class PremiumUnlockPage extends StatefulWidget {
  final SubscriptionManager subscriptionManager;

  const PremiumUnlockPage({
    super.key,
    required this.subscriptionManager,
  });

  @override
  State<PremiumUnlockPage> createState() => _PremiumUnlockPageState();
}

class _PremiumUnlockPageState extends State<PremiumUnlockPage> {
  bool isLoading = false;

  Future<void> _unlock() async {
    setState(() => isLoading = true);
    final success = await widget.subscriptionManager.buyPremium();
    await widget.subscriptionManager.refreshSubscriptionStatus();
    if (!mounted) return;

    setState(() => isLoading = false);

    final snackBar = SnackBar(
      content: Text(
        success
            ? AppLocalizations.of(context).premiumUnlockSuccess
            : AppLocalizations.of(context).premiumUnlockError,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    if (success) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(loc.premiumUnlockTitle)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star_rounded, size: 80, color: Colors.amber),
            const SizedBox(height: 24),
            Text(
              loc.premiumUnlockMessage,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // ✅ プレミアム特典リスト
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFeatureItem(Icons.show_chart, loc.premiumFeature1),
                _buildFeatureItem(Icons.timeline, loc.premiumFeature2),
                _buildFeatureItem(Icons.tips_and_updates, loc.premiumFeature3),
              ],
            ),
            const SizedBox(height: 32),

            // ✅ 購入ボタン
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.lock_open),
                onPressed: isLoading ? null : _unlock,
                label: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(loc.premiumUnlockButton),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 16),
            Text(
              loc.premiumDisclaimer,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.purpleAccent, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
