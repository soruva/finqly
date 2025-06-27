import 'package:flutter/material.dart';
import 'package:finqly/l10n/generated/app_localizations.dart';
import 'package:finqly/widgets/trend_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrendPage extends StatefulWidget {
  const TrendPage({super.key});

  @override
  State<TrendPage> createState() => _TrendPageState();
}

class _TrendPageState extends State<TrendPage> {
  List<String> history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList('emotionHistory') ?? [];
    setState(() {
      history = stored.takeLast(7).toList();
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
      (i) => FlSpot(i.toDouble(), scores[emotions[i].toLowerCase()]?.toDouble() ?? 3),
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
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: history.isEmpty
            ? Center(child: Text(loc.noTrendData))
            : Column(
                children: [
                  Text(loc.trendForecastDescription,
                      style: const TextStyle(fontSize: 16), textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  Expanded(child: TrendChart(dataPoints: spots, labels: labels)),
                ],
              ),
      ),
    );
  }
}

extension on List<String> {
  List<String> takeLast(int count) => skip(length - count).toList();
}
