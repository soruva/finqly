// lib/screens/report_page.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:finqly/services/report_service.dart';
import 'package:finqly/services/analytics_service.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _key = GlobalKey();
  final _report = ReportService();
  List<EmotionEntry> _data = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final d = await _report.last7Days();
    if (!mounted) return;
    setState(() => _data = d);
  }

  @override
  Widget build(BuildContext context) {
    final avg = _data.isEmpty ? 0 : (_data.map((e) => e.mood).reduce((a, b) => a + b) / _data.length);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              await _report.shareReport(_key);
              AnalyticsService.logEvent('report_shared', {'week_avg': avg});
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: RepaintBoundary(
              key: _key,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('Your emotion trend (last 7 days)',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 220,
                        child: _data.isEmpty
                            ? const Center(child: Text('No data yet'))
                            : LineChart(
                                LineChartData(
                                  minY: 0,
                                  maxY: 5,
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: [
                                        for (int i = 0; i < _data.length; i++)
                                          FlSpot(i.toDouble(), _data[i].mood.toDouble()),
                                      ],
                                      isCurved: true,
                                      dotData: FlDotData(show: true),
                                      barWidth: 3,
                                    ),
                                  ],
                                  titlesData: FlTitlesData(
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        interval: 1,
                                        reservedSize: 28,
                                      ),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        interval: 1,
                                        getTitlesWidget: (v, _) {
                                          final i = v.toInt();
                                          if (i < 0 || i >= _data.length) return const SizedBox();
                                          final d = _data[i].date;
                                          return Text('${d.month}/${d.day}', style: const TextStyle(fontSize: 10));
                                        },
                                      ),
                                    ),
                                  ),
                                  gridData: const FlGridData(show: true),
                                  borderData: FlBorderData(show: false),
                                ),
                              ),
                      ),
                      const SizedBox(height: 12),
                      Text('Weekly average: ${avg.toStringAsFixed(2)} / 5'),
                      const SizedBox(height: 6),
                      const Text('Tip: Keep steady habits to improve your investing mindset.'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
