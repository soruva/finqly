import 'package:flutter/material.dart';
import 'package:finqly/l10n/app_localizations.dart';
import 'package:finqly/screens/premium_unlock_page.dart';
import 'package:finqly/services/subscription_manager.dart';

class BadgeScreen extends StatelessWidget {
  final String emotionKey;
  final SubscriptionManager subscriptionManager;

  const BadgeScreen({
    super.key,
    required this.emotionKey,
    required this.subscriptionManager,
  });

  String _getBadgeText(AppLocalizations loc, String key) {
    switch (key.toLowerCase()) {
      case 'optimistic':
        return loc.badgeOptimistic;
      case 'neutral':
        return loc.badgeNeutral;
      case 'worried':
        return loc.badgeWorried;
      case 'confused':
        return loc.badgeConfused;
      case 'excited':
        return loc.badgeExcited;
      case 'cautious':
        return loc.badgeCautious;
      default:
        return loc.badgeNeutral;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final badgeImagePath = 'assets/images/badges/${emotionKey.toLowerCase()}.png';
    final isSubscribed = subscriptionManager.isSubscribed;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          loc.diagnosisTitle,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF7B44C6),
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7B44C6), Color(0xFF72C6EF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 16,
                        offset: Offset(0, 7),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    badgeImagePath,
                    width: 130,
                    height: 130,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(Icons.emoji_emotions, size: 100, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                _getBadgeText(loc, emotionKey),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  shadows: [
                    Shadow(color: Colors.black26, blurRadius: 3),
                  ],
                ),
              ),
              const SizedBox(height: 35),
              if (isSubscribed) ...[
                ElevatedButton.icon(
                  icon: const Icon(Icons.check_circle_outline, color: Colors.amber),
                  onPressed: () => Navigator.pop(context),
                  label: Text(loc.startButton),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 15),
                    backgroundColor: Colors.white.withOpacity(0.92),
                    foregroundColor: const Color(0xFF7B44C6),
                    textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                )
              ] else ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    loc.premiumPrompt,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 13),
                ElevatedButton.icon(
                  icon: const Icon(Icons.lock_open),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PremiumUnlockPage(
                          subscriptionManager: subscriptionManager,
                        ),
                      ),
                    );
                  },
                  label: Text(loc.unlockInsights),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 15),
                    backgroundColor: Colors.amber[700],
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
