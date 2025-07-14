import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TrendChart extends StatelessWidget {
  final List<FlSpot> dataPoints;
  final List<String> labels;
  final Color lineColor;

  const TrendChart({
    super.key,
    required this.dataPoints,
    required this.labels,
    this.lineColor = Colors.blueAccent,
  });

  @override
  Widget build(BuildContext context) {
    // minY/maxYを少しだけ余裕を持たせる
    double minY = 0;
    double maxY = 6;
    if (dataPoints.isNotEmpty) {
      final ys = dataPoints.map((e) => e.y).toList();
      minY = ys.reduce((a, b) => a < b ? a : b);
      maxY = ys.reduce((a, b) => a > b ? a : b);
      // 余裕を持たせる
      minY = (minY - 0.5).clamp(0, 6);
      maxY = (maxY + 0.5).clamp(0, 6);
    }

    return AspectRatio(
      aspectRatio: 1.7,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LineChart(
          LineChartData(
            minY: minY,
            maxY: maxY,
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < labels.length) {
                      return Text(labels[index], style: const TextStyle(fontSize: 10));
                    }
                    return const SizedBox.shrink();
                  },
                  interval: 1,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  interval: 1,
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: FlGridData(show: true),
            borderData: FlBorderData(
              show: true,
              border: const Border(
                left: BorderSide(),
                bottom: BorderSide(),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: dataPoints,
                isCurved: false, // 曲線だとはみ出すためfalseを推奨
                barWidth: 3,
                color: lineColor,
                dotData: FlDotData(show: true),
              )
            ],
          ),
        ),
      ),
    );
  }
}
