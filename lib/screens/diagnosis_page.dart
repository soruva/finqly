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
    with TickerProviderStateMixin {
  String? selectedEmotionKey;
  bool isPremiumUser = false;

  final _emojis = {
    'Optimistic': '😊',
    'Neutral': '😐',
    'Worried': '😟',
    'Confused': '😕',
    'Excited': '🤩',
    'Cautious': '🤔',
  };

  final Map<String, AnimationController> _controllers = {};
  final Map<String, Animation<double>> _animations = {};

  @override
  void initState() {
    super.initState();
    _loadPremiumStatus();
    // エモジーボタン用アニメーション初期化
    for (var key in _emojis.keys) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
        lowerBound: 1.0,
        upperBound: 1.12,
      );
      _controllers[key] = controller;
      _animations[key] = Tween<double>(begin: 1.0, end: 1.12).animate(
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut),
      );
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _loadPremiumStatus() {
    setState(() {
      isPremiumUser = widget.subscriptionManager.isSubscribed;
    });
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
        title: Text(loc.diagnosisTitle,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
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
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                loc.diagnosisQuestion,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      fontSize: 23,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 35),
              ...emotionOptions.entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: GestureDetector(
                    onTapDown: (_) => _controllers[entry.key]?.forward(),
                    onTapUp: (_) => _controllers[entry.key]?.reverse(),
                    onTapCancel: () => _controllers[entry.key]?.reverse(),
                    child: ScaleTransition(
                      scale: _animations[entry.key]!,
                      child: ElevatedButton.icon(
                        icon: Text(
                          _emojis[entry.key] ?? '',
                          style: const TextStyle(fontSize: 29),
                        ),
                        label: Text(
                          entry.value,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(56),
                          maximumSize: const Size.fromHeight(56),
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          shadowColor: Colors.indigo.withOpacity(0.15),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        ),
                        onPressed: () async {
                          setState(() => selectedEmotionKey = entry.key);
                          await _saveEmotionToHistory(entry.key);

                          // 選択アニメを強調
                          await _controllers[entry.key]?.forward();
                          await Future.delayed(const Duration(milliseconds: 180));
                          await _controllers[entry.key]?.reverse();

                          if (isPremiumUser) {
                            // バッジ画面へ
                            if (!mounted) return;
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
                            // Premium誘導
                            if (!mounted) return;
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
              ),
              const SizedBox(height: 26),
              if (!isPremiumUser)
                Text(
                  loc.premiumPrompt,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 16),
                child: Text(
                  "Finqly • Emotions x Investing",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
