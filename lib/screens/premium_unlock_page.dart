// lib/screens/premium_unlock_page.dart
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
  late final IapService _iap; // シングルトン
  bool _isLoading = false;
  bool _initializing = true;
  String? _error;

  // サブスクSKUが取れない（地域未提供/Play設定未完など）のフラグ
  bool _subsProductMissing = false;

  @override
  void initState() {
    super.initState();
    _iap = IapService();
    _initIap();
  }

  Future<void> _initIap() async {
    setState(() {
      _initializing = true;
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
      if (mounted) setState(() => _initializing = false);
    }
  }

  // IapService は他画面でも共有するので dispose() は呼ばない
  @override
  void dispose() {
    super.dispose();
  }

  String _monthlyPriceLabel() {
    // 価格がまだ取れない場合のフォールバック
    final price = _iap.priceForSubscription();
    return price.isNotEmpty ? price : '\$9.99 / month';
  }

  // 取得済み ProductDetails を参照
  dynamic _pd(String id) {
    try {
      return _iap.products.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> _buyMonthly() async {
    if (_isLoading) return;

    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final loc = AppLocalizations.of(context)!;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // 月額（yearly: false）で購入
      await _iap.buySubscription(yearly: false);
      await widget.subscriptionManager.setSubscribed(true);

      messenger.showSnackBar(
        SnackBar(content: Text(loc.premiumUnlockSuccess)),
      );
      navigator.maybePop();
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
      messenger.showSnackBar(
        SnackBar(content: Text('${loc.premiumUnlockError}: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    final canPurchase = _iap.isAvailable && !_isLoading && !_initializing && !_subsProductMissing;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.premiumUnlockTitle),
        actions: [
          IconButton(
            onPressed: _initializing ? null : _initIap,
            tooltip: 'Reload',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
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
            const SizedBox(height: 24),

            // 機能一覧
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFeatureItem(Icons.show_chart, loc.premiumFeature1),
                _buildFeatureItem(Icons.timeline, loc.premiumFeature2),
                _buildFeatureItem(Icons.tips_and_updates, loc.premiumFeature3),
              ],
            ),

            const SizedBox(height: 24),

            // エラー表示
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),

            // サブスクSKUが見つからない/利用不可の時のガイダンス
            if (_subsProductMissing || !_iap.isAvailable)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Card(
                  color: const Color(0xFFFFF3E0),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: const Padding(
                    padding: EdgeInsets.all(14),
                    child: Text(
                      'Subscriptions are not available for this build/region/account yet.\n'
                      'Check Play Console settings (base plan active, pricing/countries set) '
                      'and make sure your tester account is opted-in.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ),

            // 購入ボタン（グラデ背景）
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
              child: ElevatedButton(
                onPressed: canPurchase ? _buyMonthly : null,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  disabledBackgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.lock_open, color: Colors.white),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              // 例: "Unlock now — ¥1,050 / month"
                              '${loc.premiumUnlockButton} — ${_monthlyPriceLabel()}',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.5,
                                letterSpacing: 0.3,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'All payments are processed securely via Google Play Billing. '
              'Subscriptions auto-renew unless canceled. You can cancel anytime from your Google Play account.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            if (_initializing) const LinearProgressIndicator(minHeight: 2),
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
