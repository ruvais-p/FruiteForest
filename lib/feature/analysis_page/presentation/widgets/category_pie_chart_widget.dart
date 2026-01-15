import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CategoryPieChart extends StatelessWidget {
  final Map<String, double> data;

  const CategoryPieChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: data.entries.map((e) {
          return PieChartSectionData(title: e.key, value: e.value, radius: 70);
        }).toList(),
      ),
    );
  }
}
