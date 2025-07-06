import 'package:flutter/material.dart';
import 'package:finqly/l10n/app_localizations.dart';
import 'package:finqly/widgets/trend_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finqly/services/user_subscription_status.dart';
import 'package:finqly/screens/premium_unlock_page.dart';
import 'package:finqly/services/subscription_manager.dart';

class TrendPage extends StatefulWidget {
  final SubscriptionManager subscriptionManager;
  const TrendPage({super.key, required this.subscriptionManager});

  @override
  State<TrendPage> createState() => _TrendPageState();
}

class _TrendPageState extends State<TrendPage> {
  List<String> history = [];
  bool isPremium = false;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList('emotionHistory') ?? [];
    final premium = await UserSubscriptionStatus().isPremium();
    setState(() {
      history = stored.length <= 7 ? List.from(stored) : stored.sublist(stored.length - 7);
      isPremium = premium;
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
        scores[emotions[i].trim().toLowerCase()]?.toDouble() ?? 3,
      ),
    );
  }

  List<String> _labels(List<String> emotions) {
    return List.generate(emotions.length, (i) => 'Day ${i + 1}');
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final spots = _generateSpots(history);
    final labels = _labels(history);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.trendForecastTitle),
        centerTitle: true,
      ),
      body: isPremium
          ? Padding(
              padding: const EdgeInsets.all(24),
              child: history.isEmpty
                  ? Center(child: Text(loc.noTrendData))
                  : Column(
                      children: [
                        Text(
                          loc.trendForecastDescription,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 18),
                        Expanded(child: TrendChart(dataPoints: spots, labels: labels)),
                        const SizedBox(height: 18),
                        Text(
                          "Score Legend: 6=Excited, 5=Optimistic, 3=Neutral, 2=Confused, 1=Worried, 0=Cautious",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_outline, size: 70, color: Colors.grey),
                  const SizedBox(height: 20),
                  Text(
                    // 1行目: なぜ見れないか／2行目: Premiumで何が得られるか
                    "${loc.premiumPrompt}\n\nUnlock trend charts, performance tracking, and personalized insights with Finqly Plus!",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 22),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.lock_open),
                    label: Text(loc.unlockInsights),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
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
                      // Premiumページから戻ったら即リフレッシュ
                      await _loadAll();
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
