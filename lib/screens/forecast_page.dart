import 'package:flutter/material.dart';
import 'package:finqly/theme/colors.dart';
import 'package:finqly/l10n/app_localizations.dart';
import 'package:finqly/screens/premium_unlock_page.dart';
import 'package:finqly/services/subscription_manager.dart';
import 'package:finqly/screens/particle_background.dart';
import 'dart:math';

class ForecastPage extends StatelessWidget {
  final SubscriptionManager subscriptionManager;
  const ForecastPage({super.key, required this.subscriptionManager});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return ValueListenableBuilder<bool>(
      valueListenable: subscriptionManager.isSubscribedNotifier,
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
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PremiumUnlockPage(
                  subscriptionManager: subscriptionManager,
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
