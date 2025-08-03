import 'package:flutter/material.dart';
import 'package:finqly/services/subscription_manager.dart';
import 'package:finqly/services/history_service.dart';
import 'package:intl/intl.dart';
import 'package:finqly/screens/premium_unlock_page.dart';
import 'package:finqly/l10n/app_localizations.dart';

class EmotionHistoryPage extends StatefulWidget {
  final SubscriptionManager subscriptionManager;
  const EmotionHistoryPage({super.key, required this.subscriptionManager});

  @override
  State<EmotionHistoryPage> createState() => _EmotionHistoryPageState();
}

class _EmotionHistoryPageState extends State<EmotionHistoryPage> {
  List<Map<String, dynamic>> _history = [];

  final Map<String, String> _emojis = {
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
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final fullHistory = await HistoryService().getHistory();
    setState(() => _history = fullHistory);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return ValueListenableBuilder<bool>(
      valueListenable: widget.subscriptionManager.isSubscribedNotifier,
      builder: (context, isPremium, _) {
        final visibleHistory = isPremium
            ? _history
            : (_history.length > 7 ? _history.sublist(_history.length - 7) : _history);

        return Scaffold(
          appBar: AppBar(
            title: Text(loc.emotionHistoryTitle),
            centerTitle: true,
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
          body: _history.isEmpty
              ? Center(
                  child: Text(
                    loc.emotionHistoryEmpty,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0, bottom: 10.0),
                      child: Text(
                        isPremium
                            ? loc.emotionHistoryTitle // e.g. "Emotion History"
                            : "${loc.emotionHistoryTitle} (last 7 records)",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: visibleHistory.length,
                        itemBuilder: (context, idx) {
                          final item = visibleHistory[visibleHistory.length - idx - 1];
                          final date = item['timestamp'] ?? '';
                          final emotion = item['emotion'] ?? '';
                          String formattedDate = '';
                          if (date is String && date.isNotEmpty) {
                            try {
                              final dt = DateTime.parse(date);
                              formattedDate = DateFormat('yyyy/MM/dd HH:mm').format(dt);
                            } catch (_) {
                              formattedDate = date;
                            }
                          }
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                            elevation: 3,
                            child: ListTile(
                              leading: Text(
                                _emojis[emotion] ?? '📝',
                                style: const TextStyle(fontSize: 30),
                              ),
                              title: Text(
                                loc is AppLocalizations
                                    ? _localizeEmotion(loc, emotion)
                                    : emotion,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                formattedDate,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (!isPremium && _history.length > 7)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              loc.premiumFeatureExplain,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 7),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.lock_open),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                                minimumSize: const Size.fromHeight(48),
                              ),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PremiumUnlockPage(
                                      subscriptionManager: widget.subscriptionManager,
                                    ),
                                  ),
                                );
                                await _loadHistory();
                              },
                              label: Text(
                                loc.unlockInsights,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 6),
                  ],
                ),
        );
      },
    );
  }

  String _localizeEmotion(AppLocalizations loc, String emotion) {
    switch (emotion) {
      case 'Optimistic':
        return loc.optionOptimistic;
      case 'Neutral':
        return loc.optionNeutral;
      case 'Worried':
        return loc.optionWorried;
      case 'Confused':
        return loc.optionConfused;
      case 'Excited':
        return loc.optionExcited;
      case 'Cautious':
        return loc.optionCautious;
      default:
        return emotion;
    }
  }
}
