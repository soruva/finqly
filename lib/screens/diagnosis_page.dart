import 'package:flutter/material.dart';
import 'package:finqly/theme/colors.dart';
import 'package:finqly/l10n/app_localizations.dart';
import 'package:finqly/screens/badge_screen.dart';
import 'package:finqly/screens/premium_unlock_page.dart';
import 'package:finqly/services/subscription_manager.dart';
import 'package:finqly/services/history_service.dart';

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

  Future<void> _saveEmotionToHistory(String emotion) async {
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
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF7B44C6), Color(0xFF72C6EF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        loc.diagnosisQuestion,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: 22,
                          letterSpacing: 0.1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ...emotionOptions.entries.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: _emotionButton(
                          icon: _emojis[entry.key] ?? '',
                          label: entry.value,
                          onTap: () async {
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
                    const SizedBox(height: 34),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 18, left: 4, right: 4),
                        child: Text(
                          loc.premiumPrompt,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _emotionButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.96),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(1, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 18),
            Text(
              icon,
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF462066),
                  letterSpacing: 0.1,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
