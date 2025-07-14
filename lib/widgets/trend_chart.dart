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
    return AspectRatio(
      aspectRatio: 1.7,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: LineChart(
          LineChartData(
            minY: 0,
            maxY: 6,
            gridData: FlGridData(
              show: true,
              horizontalInterval: 1,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) => FlLine(
                color: Colors.grey.withOpacity(0.12),
                strokeWidth: 1,
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: const Border(
                left: BorderSide(width: 1, color: Colors.black26),
                bottom: BorderSide(width: 1, color: Colors.black26),
                right: BorderSide.none,
                top: BorderSide.none,
              ),
            ),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < labels.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          labels[index],
                          style: const TextStyle(fontSize: 10, color: Colors.black54),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                  interval: 1,
                  reservedSize: 22,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) => Padding(
                    padding: const EdgeInsets.only(right: 3),
                    child: Text(
                      value.toInt().toString(),
                      style: const TextStyle(fontSize: 10, color: Colors.black54),
                    ),
                  ),
                  interval: 1,
                  reservedSize: 24,
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: dataPoints,
                isCurved: true,
                barWidth: 3,
                color: lineColor,
                dotData: FlDotData(show: true),
                belowBarData: BarAreaData(
                  show: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
