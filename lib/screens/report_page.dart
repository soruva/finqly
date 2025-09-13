// lib/screens/report_page.dart
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final GlobalKey _cardKey = GlobalKey();
  bool _busy = false;

  final List<double> _points = const [3, 3, 3, 3, 3, 3, 3];
  final List<String> _labels = const ['9/6', '9/7', '9/8', '9/9', '9/10', '9/11', '9/12'];

  Future<void> _shareCard() async {
    if (_busy) return;
    setState(() => _busy = true);
    final messenger = ScaffoldMessenger.of(context);

    try {
      final boundary = _cardKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) throw StateError('Render boundary not found');

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();

      final tmpDir = await getTemporaryDirectory();
      final path = '${tmpDir.path}/finqly_emotion_trend.png';
      final file = XFile.fromData(
        pngBytes,
        name: 'finqly_emotion_trend.png',
        mimeType: 'image/png',
        path: path,
      );

      await Share.shareXFiles([file], text: 'My emotion trend from Finqly');
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Share failed: $e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final avg = _points.isEmpty ? 0 : _points.reduce((a, b) => a + b) / _points.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Report'),
        actions: [
          IconButton(
            tooltip: 'Share as image',
            onPressed: _busy ? null : _shareCard,
            icon: const Icon(Icons.ios_share_rounded),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(color: const Color(0xFF0E0E12)),
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              RepaintBoundary(
                key: _cardKey,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1F26),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Flexible(
                            child: Text(
                              'Your emotion trend\n(last 7 days)',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                height: 1.2,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF262A33),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Avg ${avg.toStringAsFixed(2)} / 5',
                              style: const TextStyle(color: Color(0xFF8F8BFF), fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 220,
                        child: LineChart(
                          LineChartData(
                            minY: 0,
                            maxY: 5,
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: true,
                              horizontalInterval: 1,
                              verticalInterval: 1,
                              getDrawingHorizontalLine: (v) =>
                                  FlLine(color: const Color(0xFF2A2F3A), strokeWidth: 1),
                              getDrawingVerticalLine: (v) =>
                                  FlLine(color: const Color(0xFF2A2F3A), strokeWidth: 1),
                            ),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 24,
                                  getTitlesWidget: (v, _) => Text(
                                    v == v.roundToDouble() ? v.toInt().toString() : '',
                                    style: const TextStyle(color: Color(0xFF9AA3B2), fontSize: 11),
                                  ),
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (v, _) {
                                    final i = v.toInt();
                                    if (i < 0 || i >= _labels.length) return const SizedBox.shrink();
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Text(
                                        _labels[i],
                                        style: const TextStyle(color: Color(0xFF9AA3B2), fontSize: 11),
                                      ),
                                    );
                                  },
                                  interval: 1,
                                  reservedSize: 24,
                                ),
                              ),
                              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                            borderData: FlBorderData(
                              show: true,
                              border: const Border(
                                top: BorderSide(color: Color(0xFF2A2F3A)),
                                bottom: BorderSide(color: Color(0xFF2A2F3A)),
                                left: BorderSide(color: Color(0xFF2A2F3A)),
                                right: BorderSide(color: Color(0xFF2A2F3A)),
                              ),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: [
                                  for (int i = 0; i < _points.length; i++) FlSpot(i.toDouble(), _points[i]),
                                ],
                                isCurved: false,
                                barWidth: 3,
                                color: const Color(0xFF19D5E4),
                                dotData: FlDotData(show: true),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Weekly average: ${avg.toStringAsFixed(2)} / 5',
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'This week was steady. Keep consistent habits!',
                        style: TextStyle(color: Color(0xFFBAC1CE), fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),
              const Text(
                'Tip: Use the share button in the top-right to export an image. '
                'Buttons are excluded from the image.',
                style: TextStyle(color: Color(0xFF98A2B3), fontSize: 12),
              ),
              const SizedBox(height: 80),
            ],
          ),

          if (_busy)
            Container(
              color: Colors.black.withOpacity(0.35),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
