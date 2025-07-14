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
    // Clamp all y-values to 0-6 just in case
    final clampedSpots = dataPoints
        .map((e) => FlSpot(e.x, e.y.clamp(0, 6)))
        .toList();

    return AspectRatio(
      aspectRatio: 1.7,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LineChart(
          LineChartData(
            minY: 0,
            maxY: 6,
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
                spots: clampedSpots,
                isCurved: true,
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
