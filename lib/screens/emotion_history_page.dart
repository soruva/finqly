import 'package:flutter/material.dart';
import 'package:finqly/services/subscription_manager.dart';
import 'package:finqly/services/history_service.dart';
import 'package:intl/intl.dart';
import 'package:finqly/screens/premium_unlock_page.dart';

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
    final isPremium = widget.subscriptionManager.isSubscribed;
    final visibleHistory = isPremium
        ? _history
        : (_history.length > 7 ? _history.sublist(_history.length - 7) : _history);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emotion History'),
        centerTitle: true,
      ),
      body: _history.isEmpty
          ? const Center(
              child: Text(
                'No history yet.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 18.0, bottom: 10.0),
                  child: Text(
                    isPremium
                        ? "Your full diagnosis history"
                        : "Recent 7 records (upgrade for full history)",
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
                            emotion,
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
                    child: ElevatedButton.icon(
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
                      label: const Text(
                        'Unlock full history',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                const SizedBox(height: 6),
              ],
            ),
    );
  }
}
