import 'package:flutter/material.dart';
import 'package:finqly/theme/colors.dart';
import 'package:finqly/l10n/app_localizations.dart';
import 'package:finqly/screens/badge_screen.dart';
import 'package:finqly/screens/premium_unlock_page.dart';
import 'package:finqly/services/subscription_manager.dart';
import 'package:finqly/services/history_service.dart'; // ←ここ追加

class DiagnosisPage extends StatefulWidget {
  final SubscriptionManager subscriptionManager;

  const DiagnosisPage({super.key, required this.subscriptionManager});

  @override
  State<DiagnosisPage> createState() => _DiagnosisPageState();
}

class _DiagnosisPageState extends State<DiagnosisPage> {
  String? selectedEmotionKey;

  final _emojis = {
    'Optimistic': '😊',
    'Neutral': '😐',
    'Worried': '😟',
    'Confused': '😕',
    'Excited': '🤩',
    'Cautious': '🤔',
  };

  /// タイムスタンプ付きで履歴保存（HistoryService利用！）
  Future<void> _saveEmotionToHistory(String emotion) async {
    // emotionKeyは英語名（"Optimistic"など）で保存
    await HistoryService().addEntry(emotion);
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

    // プレミアム状態をリアルタイム監視
    return ValueListenableBuilder<bool>(
      valueListenable: widget.subscriptionManager.isSubscribedNotifier,
      builder: (context, isPremiumUser, _) {
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    loc.diagnosisQuestion,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: 22,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ...emotionOptions.entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4),
                      child: SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _emojis[entry.key] ?? '',
                                style: const TextStyle(fontSize: 28),
                              ),
                              const SizedBox(width: 18),
                              Text(
                                entry.value,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
