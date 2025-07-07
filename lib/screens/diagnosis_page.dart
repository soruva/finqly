import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finqly/theme/colors.dart';
import 'package:finqly/l10n/app_localizations.dart';
import 'package:finqly/screens/badge_screen.dart';
import 'package:finqly/screens/premium_unlock_page.dart';
import 'package:finqly/services/subscription_manager.dart';

class DiagnosisPage extends StatefulWidget {
  final SubscriptionManager subscriptionManager;

  const DiagnosisPage({super.key, required this.subscriptionManager});

  @override
  State<DiagnosisPage> createState() => _DiagnosisPageState();
}

class _DiagnosisPageState extends State<DiagnosisPage>
    with SingleTickerProviderStateMixin {
  String? selectedEmotionKey;
  bool isPremiumUser = false;
  late AnimationController _controller;

  final _emojis = {
    'Optimistic': '😊',
    'Neutral': '😐',
    'Worried': '😟',
    'Confused': '😕',
    'Excited': '🤩',
    'Cautious': '🤔',
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    isPremiumUser = widget.subscriptionManager.isSubscribed;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveEmotionToHistory(String emotion) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('emotionHistory') ?? [];
    history.add(emotion);
    await prefs.setStringList('emotionHistory', history);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final emotionOptions = {
      'Optimistic': loc.optionOptimistic,
      'Neutral': loc.optionNeutral,
      'Worried': loc.optionWorried,
      'Confused': loc.optionConfused,
      'Excited': loc.optionExcited,
      'Cautious': loc.optionCautious,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.diagnosisTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7B44C6), Color(0xFF72C6EF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  loc.diagnosisQuestion,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 22,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                // エモジ＋ボタン
                ...emotionOptions.entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        double angle = 0.03 * sin(_controller.value * 2 * pi);
                        return Transform.rotate(
                          angle: angle,
                          child: child,
                        );
                      },
                      child: ElevatedButton.icon(
                        icon: Text(
                          _emojis[entry.key] ?? '',
                          style: const TextStyle(fontSize: 30),
                        ),
                        label: Text(
                          entry.value,
                          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(285, 56),
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
                        ),
                        onPressed: () async {
                          setState(() => selectedEmotionKey = entry.key);
                          await _saveEmotionToHistory(entry.key);
                          if (isPremiumUser) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BadgeScreen(
                                  emotionKey: entry.key,
                                  subscriptionManager: widget.subscriptionManager,
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PremiumUnlockPage(
                                  subscriptionManager: widget.subscriptionManager,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                if (!isPremiumUser)
                  Text(
                    loc.premiumPrompt,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
