import 'package:flutter/material.dart';
import 'package:finqly/theme/colors.dart';
import 'package:finqly/l10n/app_localizations.dart';
import 'package:finqly/screens/premium_unlock_page.dart';
import 'package:finqly/services/subscription_manager.dart';
import 'package:finqly/screens/particle_background.dart';
import 'package:finqly/services/iap_service.dart';
import 'dart:math';

class ForecastPage extends StatefulWidget {
  final SubscriptionManager subscriptionManager;
  const ForecastPage({super.key, required this.subscriptionManager});

  @override
  State<ForecastPage> createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {
  late final IapService _iap;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _iap = IapService();
    _iap.init(
      onVerified: (p) async {
        await widget.subscriptionManager.setSubscribed(true);
        if (!mounted) return;
        setState(() => _busy = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Purchase completed')));
      },
      onError: (e) {
        if (!mounted) return;
        setState(() {
          _busy = false;
          _error = e.toString();
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Purchase error: $_error')));
      },
    );
  }

  @override
  void dispose() {
    _iap.dispose();
    super.dispose();
  }

  Future<void> _showPaywall() async {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Unlock options',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.all_inclusive),
                title: const Text('Starter Bundle: Diagnosis & Insights'),
                subtitle: const Text('\$19.99 • Lifetime access'),
                onTap: _busy
                    ? null
                    : () async {
                        Navigator.pop(context);
                        setState(() => _busy = true);
                        await _iap.buyOneTime(IapService.starterBundleId);
                      },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.workspace_premium),
                title: const Text('Go Premium'),
                subtitle:
                    const Text('Monthly or Yearly subscription available'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PremiumUnlockPage(
                        subscriptionManager: widget.subscriptionManager,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return ValueListenableBuilder<bool>(
      valueListenable: widget.subscriptionManager.isSubscribedNotifier,
      builder: (context, isPremium, _) {
        final forecastPercent = isPremium ? 3 + Random().nextDouble() * 5 : 0;

        return Scaffold(
          appBar: AppBar(
            title: Text(loc.forecastTitle),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          body: Stack(
            children: [
              if (!isPremium) const ParticleBackground(),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: isPremium
                      ? const LinearGradient(
                          colors: [AppColors.primary, AppColors.accentPurple],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isPremium ? null : Colors.black.withOpacity(0.5),
                ),
                child: isPremium
                    ? _buildPremiumView(loc, forecastPercent.toDouble(), context)
                    : _buildLockedView(loc, context),
              ),
              if (_busy)
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: LinearProgressIndicator(minHeight: 2),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPremiumView(
      AppLocalizations loc, double forecastPercent, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShaderMask(
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              colors: [Colors.amber, Colors.deepOrangeAccent],
            ).createShader(bounds);
          },
          child: const Icon(Icons.trending_up, size: 90, color: Colors.white),
        ),
        const SizedBox(height: 24),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: forecastPercent),
          duration: const Duration(seconds: 2),
          curve: Curves.easeOutExpo,
          builder: (context, value, child) {
            return Text(
              loc.forecastMessage(value.toStringAsFixed(1)),
              style: const TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            );
          },
        ),
        const SizedBox(height: 32),
        ElevatedButton.icon(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          icon: const Icon(Icons.arrow_back),
          label: Text(loc.startButton),
        ),
      ],
    );
  }

  Widget _buildLockedView(AppLocalizations loc, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.lock_outline, size: 90, color: Colors.white),
        const SizedBox(height: 24),
        Text(
          loc.premiumPrompt,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 14),
        Text(
          "🔒 ${loc.premiumFeatureExplain}",
          style: const TextStyle(
            fontSize: 15,
            color: Colors.white70,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        ElevatedButton.icon(
          onPressed: _showPaywall,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          icon: const Icon(Icons.lock_open),
          label: Text(loc.premiumCTA),
        ),
        if (_error != null) ...[
          const SizedBox(height: 8),
          Text('Error: $_error',
              style: const TextStyle(color: Colors.redAccent)),
        ],
      ],
    );
  }
}
