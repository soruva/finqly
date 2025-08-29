import 'package:flutter/material.dart';
import 'package:finqly/l10n/app_localizations.dart';
import 'package:finqly/services/iap_service.dart';
import 'package:finqly/services/subscription_manager.dart';

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
  bool _isLoading = false;
  late final IapService _iap;
  String? _error;

  @override
  void initState() {
    super.initState();
    _iap = IapService();
    _initIap();
  }

  Future<void> _initIap() async {
    try {
      await _iap.init();
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    }
  }

  @override
  void dispose() {
    _iap.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFeatureItem(Icons.show_chart, loc.premiumFeature1),
                _buildFeatureItem(Icons.timeline, loc.premiumFeature2),
                _buildFeatureItem(Icons.tips_and_updates, loc.premiumFeature3),
              ],
            ),
            const SizedBox(height: 32),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8267BE), Color(0xFF47C6E6)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 12,
                    offset: const Offset(1, 6),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.lock_open, color: Colors.white),
                onPressed: _isLoading
                    ? null
                    : () async {
                        setState(() {
                          _isLoading = true;
                          _error = null;
                        });
                        try {
                          await _iap.buySubscription(yearly: false);
                          if (!mounted) return;
                          await widget.subscriptionManager.setSubscribed(true);
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Purchase complete')),
                          );
                          Navigator.of(context).maybePop();
                        } catch (e) {
                          if (!mounted) return;
                          setState(() => _error = e.toString());
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Purchase error: $e')),
                          );
                        } finally {
                          if (mounted) setState(() => _isLoading = false);
                        }
                      },
                label: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : Text(
                        loc.premiumUnlockButton,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          letterSpacing: 0.5,
                          color: Colors.white,
                        ),
                      ),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'All payments are processed securely via Google Play Billing. '
              'Subscriptions auto-renew unless canceled. You can cancel anytime from your Google Play account.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
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
