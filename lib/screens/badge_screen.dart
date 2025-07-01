import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finqly/l10n/app_localizations.dart'; // ←ここだけ修正
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

  Future<void> saveEmotionToHistory(String emotion) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('emotionHistory') ?? [];
    history.add(emotion);
    await prefs.setStringList('emotionHistory', history);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    String getBadgeText(String key) {
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

    final badgeImagePath = 'assets/images/badges/${emotionKey.toLowerCase()}.png';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      saveEmotionToHistory(emotionKey);
    });

    final isSubscribed = subscriptionManager.isSubscribed;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          loc.diagnosisTitle,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                badgeImagePath,
                width: 160,
                height: 160,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.emoji_emotions, size: 120),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              getBadgeText(emotionKey),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 24),
            if (isSubscribed)
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: Text(loc.startButton),
              )
            else ...[
              Text(
                loc.premiumPrompt,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
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
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: Text(loc.unlockInsights),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
