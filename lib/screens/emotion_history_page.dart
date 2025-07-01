import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finqly/l10n/generated/app_localizations.dart';
import 'package:finqly/services/user_subscription_status.dart';
import 'package:finqly/screens/premium_unlock_page.dart';

class EmotionHistoryPage extends StatefulWidget {
  const EmotionHistoryPage({super.key});

  @override
  State<EmotionHistoryPage> createState() => _EmotionHistoryPageState();
}

class _EmotionHistoryPageState extends State<EmotionHistoryPage> {
  List<String> emotionHistory = [];
  bool isPremiumUser = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('emotionHistory') ?? [];
    final premium = await UserSubscriptionStatus().isPremium();
    setState(() {
      emotionHistory = history.reversed.toList();
      isPremiumUser = premium;
    });
  }

  String getImagePath(String emotion) {
    final key = emotion.toLowerCase();
    return 'assets/images/badges/$key.png';
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(loc.emotionHistoryTitle)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: isPremiumUser
            ? emotionHistory.isEmpty
                ? Center(child: Text(loc.noHistoryFound))
                : ListView.separated(
                    itemCount: emotionHistory.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final emotion = emotionHistory[index];
                      final imagePath = getImagePath(emotion);

                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              imagePath,
                              width: 48,
                              height: 48,
                              errorBuilder: (_, __, ___) => const Icon(Icons.emoji_emotions, size: 40),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                emotion,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lock_outline, size: 60, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      loc.unlockInsights,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => PremiumUnlockPage(subscriptionManager: subscriptionManager)),
                        );
                      },
                      child: Text(loc.upgradeToPremium),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
