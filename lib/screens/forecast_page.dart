import 'package:flutter/material.dart';
import 'package:finqly/theme/colors.dart';
import 'package:finqly/l10n/generated/app_localizations.dart';
import 'package:finqly/services/user_subscription_status.dart';
import 'package:finqly/screens/premium_unlock_page.dart';
import 'package:finqly/services/subscription_manager.dart';
import 'dart:math';

class ForecastPage extends StatefulWidget {
  final SubscriptionManager subscriptionManager;
  const ForecastPage({super.key, required this.subscriptionManager});

  @override
  State<ForecastPage> createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage>
    with SingleTickerProviderStateMixin {
  bool isPremium = false;
  double forecastPercent = 0;

  @override
  void initState() {
    super.initState();
    _checkPremiumStatus();
  }

  Future<void> _checkPremiumStatus() async {
    final status = await UserSubscriptionStatus().isPremium();
    setState(() {
      isPremium = status;
      if (isPremium) {
        forecastPercent = 3 + Random().nextDouble() * 5; // 3〜8%
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.forecastTitle),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.accentPurple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: isPremium ? _buildPremiumView(loc) : _buildLockedView(loc),
      ),
    );
  }

  Widget _buildPremiumView(AppLocalizations loc) {
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

  Widget _buildLockedView(AppLocalizations loc) {
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
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PremiumUnlockPage(
                  subscriptionManager: widget.subscriptionManager,
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          icon: const Icon(Icons.lock_open),
          label: Text(loc.premiumCTA),
        ),
      ],
    );
  }
}
