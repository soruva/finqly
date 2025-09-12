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
  final _boundaryKey = GlobalKey();
  final _report = ReportService();

  List<EmotionEntry> _data = const [];
  ReportSummary? _summary;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final d = await _report.last7Days();
      final s = await _report.weeklySummary();
      if (!mounted) return;
      setState(() {
        _data = d;
        _summary = s;
      });
    } catch (_) {
      // no-op
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _share() async {
    try {
      await _report.shareReport(_boundaryKey);
      final avg = _summary?.averageMood ?? 0;
      try {
        AnalyticsService.logEvent('report_shared', {'week_avg': avg});
      } catch (_) {}
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to share report: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final avg = _summary?.averageMood ?? 0.0;
    final delta = _summary?.deltaFromStart ?? 0;
    final theme = Theme.of(context);
    final deltaText =
        delta == 0 ? '±0' : (delta > 0 ? '+$delta' : '$delta');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _load,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _share,
            tooltip: 'Share',
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
              key: _boundaryKey,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _loading
                      ? const SizedBox(
                          height: 240,
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Your emotion trend (last 7 days)',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                if (_summary != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      'Avg ${avg.toStringAsFixed(2)} / 5 • Δ $deltaText',
                                      style: theme.textTheme.labelMedium?.copyWith(
                                        color: theme.colorScheme.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
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
                                                if (i < 0 || i >= _data.length) {
                                                  return const SizedBox();
                                                }
                                                final d = _data[i].date;
                                                return Padding(
                                                  padding: const EdgeInsets.only(top: 4),
                                                  child: Text(
                                                    '${d.month}/${d.day}',
                                                    style: const TextStyle(fontSize: 10),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          rightTitles: const AxisTitles(
                                            sideTitles: SideTitles(showTitles: false),
                                          ),
                                          topTitles: const AxisTitles(
                                            sideTitles: SideTitles(showTitles: false),
                                          ),
                                        ),
                                        gridData: const FlGridData(show: true),
                                        borderData: FlBorderData(show: false),
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 12),
                            if (_summary != null) ...[
                              Text('Weekly average: ${avg.toStringAsFixed(2)} / 5'),
                              const SizedBox(height: 4),
                              Text(
                                delta == 0
                                    ? 'This week was steady. Keep consistent habits!'
                                    : (delta > 0
                                        ? 'Uptrend from week start. Nice momentum!'
                                        : 'Slight dip from week start. Small habits can help.'),
                              ),
                            ] else ...[
                              const Text('Weekly average: –'),
                              const SizedBox(height: 4),
                              const Text('Tip: Keep steady habits to improve your investing mindset.'),
                            ],
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                OutlinedButton.icon(
                                  onPressed: _share,
                                  icon: const Icon(Icons.ios_share),
                                  label: const Text('Share as image'),
                                ),
                                const SizedBox(width: 12),
                                OutlinedButton.icon(
                                  onPressed: _load,
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Refresh'),
                                ),
                              ],
                            ),
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
