import 'package:flutter/material.dart';
import 'package:finqly/services/subscription_manager.dart';
import 'package:finqly/services/history_service.dart';
import 'package:intl/intl.dart';
import 'package:finqly/screens/premium_unlock_page.dart';
import 'package:finqly/l10n/app_localizations.dart';
import 'package:finqly/services/iap_service.dart';

class EmotionHistoryPage extends StatefulWidget {
  final SubscriptionManager subscriptionManager;
  const EmotionHistoryPage({super.key, required this.subscriptionManager});

  @override
  State<EmotionHistoryPage> createState() => _EmotionHistoryPageState();
}

class _EmotionHistoryPageState extends State<EmotionHistoryPage> {
  List<Map<String, dynamic>> _history = [];

  final Map<String, String> _emojis = const {
    'Optimistic': '😊',
    'Neutral': '😐',
    'Worried': '😟',
    'Confused': '😕',
    'Excited': '🤩',
    'Cautious': '🤔',
  };

  late final IapService _iap;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadHistory();

    _iap = IapService();
    _iap.init(
      onVerified: (p) async {
        await widget.subscriptionManager.setSubscribed(true);
        await _loadHistory();
        if (!mounted) return;
        setState(() => _busy = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Purchase completed')));
      },
      onError: (e) {
        if (!mounted) return;
        setState(() {
          _busy = false;
          _error = e.toString();
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Purchase error: $_error')));
      },
    );
  }

  @override
  void dispose() {
    _iap.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    final fullHistory = await HistoryService().getHistory();
    if (!mounted) return;
    setState(() => _history = fullHistory);
  }

  Future<void> _showPaywall() async {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Unlock options',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.all_inclusive),
                title: const Text('Starter Bundle: Diagnosis & Insights'),
                subtitle: const Text('\$19.99 • Lifetime access'),
                onTap: _busy
                    ? null
                    : () async {
                        Navigator.pop(context);
                        setState(() => _busy = true);
                        await _iap.buyOneTime(IapService.starterBundleId);
                      },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.workspace_premium),
                title: const Text('Go Premium'),
                subtitle:
                    const Text('Monthly or Yearly subscription available'),
                onTap: () async {
                  Navigator.pop(context);
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
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
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
                            ? loc.emotionHistoryTitle
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
                                _localizeEmotion(loc, emotion),
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
                              onPressed: _showPaywall,
                              label: Text(
                                loc.unlockInsights,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (_busy)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: LinearProgressIndicator(minHeight: 2),
                      ),
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
                        child: Text('Error: $_error',
                            style: const TextStyle(color: Colors.red)),
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
