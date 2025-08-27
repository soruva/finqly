// lib/screens/trend_page.dart
import 'package:flutter/material.dart';
import 'package:finqly/l10n/app_localizations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:finqly/widgets/trend_chart.dart';
import 'package:finqly/screens/premium_unlock_page.dart';
import 'package:finqly/services/subscription_manager.dart';
import 'package:finqly/services/history_service.dart';

class TrendPage extends StatefulWidget {
  final SubscriptionManager subscriptionManager;
  const TrendPage({super.key, required this.subscriptionManager});

  @override
  State<TrendPage> createState() => _TrendPageState();
}

class _TrendPageState extends State<TrendPage> {
  List<String> emotions = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final historyRaw = await HistoryService().getHistory();
    final extracted =
        historyRaw.map((e) => e["emotion"]?.toString() ?? "neutral").toList();
    setState(() {
      emotions = extracted.length <= 7
          ? List.from(extracted)
          : extracted.sublist(extracted.length - 7);
    });
  }

  List<FlSpot> _generateSpots(List<String> emotions) {
    const scores = {
      'excited': 6,
      'optimistic': 5,
      'neutral': 3,
      'confused': 2,
      'worried': 1,
      'cautious': 0,
    };
    return List<FlSpot>.generate(
      emotions.length,
      (i) => FlSpot(
        i.toDouble(),
        (scores[emotions[i].trim().toLowerCase()] ?? 3).toDouble(),
      ),
    );
  }

  List<String> _labels(BuildContext context, List<String> emotions) {
    final loc = AppLocalizations.of(context)!;
    return List.generate(emotions.length, (i) => loc.dayLabel(i + 1));
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return ValueListenableBuilder<bool>(
      valueListenable: widget.subscriptionManager.isSubscribedNotifier,
      builder: (context, isPremium, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              loc.trendForecastTitle,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: isPremium
              ? Padding(
                  padding: const EdgeInsets.all(24),
                  child: emotions.isEmpty
                      ? Center(
                          child: Text(
                            loc.noTrendData,
                            style: const TextStyle(fontSize: 16),
                          ),
                        )
                      : Column(
                          children: [
                            Text(
                              loc.trendForecastDescription,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 18),
                            Expanded(
                              child: TrendChart(
                                dataPoints: _generateSpots(emotions),
                                labels: _labels(context, emotions),
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              loc.trendScoreLegend,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.lock_outline,
                          size: 74, color: Colors.grey),
                      const SizedBox(height: 28),
                      Text(
                        "${loc.premiumPrompt}\n\n${loc.premiumTrendUpsell}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.lock_open),
                        label: Text(loc.unlockInsights),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 38, vertical: 16),
                          textStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PremiumUnlockPage(
                                subscriptionManager:
                                    widget.subscriptionManager,
                              ),
                            ),
                          );
                          await _loadHistory();
                        },
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
