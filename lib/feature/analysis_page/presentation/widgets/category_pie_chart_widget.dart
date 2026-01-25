import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fruiteforest/common/theme/colors/colors.dart';
import 'package:fruiteforest/feature/analysis_page/config/analysis_config.dart';

/// Category Pie Chart Widget
///
/// Displays category distribution as a donut chart with labels.
/// Colors are configured via AnalysisConfig for consistency.
///
/// ## Usage:
/// ```dart
/// CategoryPieChart(
///   data: {'Gym': 120, 'Focus': 90, 'Reading': 60},
///   config: AnalysisConfig.defaults(),
/// )
/// ```
class CategoryPieChart extends StatelessWidget {
  /// Category name → minutes mapping
  final Map<String, double> data;

  /// Configuration for category colors
  final AnalysisConfig config;

  const CategoryPieChart({
    super.key,
    required this.data,
    AnalysisConfig? config,
  }) : config =
           config ??
           const AnalysisConfig(
             heatmapThresholds: {},
             categoryColors: {
               'Gym': AppColors.categoryGym,
               'Focus': AppColors.categoryFocus,
               'Reading': AppColors.categoryReading,
             },
           );

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(
        child: Text(
          'No data available',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    final total = data.values.fold(0.0, (sum, val) => sum + val);

    return Column(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 50,
              sections: _buildSections(total),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildLegend(context, total),
      ],
    );
  }

  List<PieChartSectionData> _buildSections(double total) {
    final List<PieChartSectionData> sections = [];

    for (final entry in data.entries) {
      final percentage = (entry.value / total * 100);
      final color = config.getCategoryColor(entry.key);

      sections.add(
        PieChartSectionData(
          value: entry.value,
          title: '${percentage.toStringAsFixed(0)}%',
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
          color: color,
          radius: 60,
          titlePositionPercentageOffset: 0.55,
        ),
      );
    }

    return sections;
  }

  Widget _buildLegend(BuildContext context, double total) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: data.entries.map((entry) {
        final color = config.getCategoryColor(entry.key);
        final minutes = entry.value.toInt();
        final hours = minutes ~/ 60;
        final mins = minutes % 60;
        final timeStr = hours > 0 ? '${hours}h ${mins}m' : '${mins}m';

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(
              '${entry.key} ($timeStr)',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        );
      }).toList(),
    );
  }
}
