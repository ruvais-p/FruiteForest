import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:fruiteforest/common/theme/colors/colors.dart';
import 'package:fruiteforest/feature/analysis_page/config/analysis_config.dart';

/// Activity Heatmap Calendar Widget
///
/// Displays daily activity data as a color-coded calendar heatmap.
/// Colors indicate intensity of activity based on configured thresholds.
///
/// ## Usage:
/// ```dart
/// ActivityHeatMap(
///   data: state.dailyMinutes,
///   config: AnalysisConfig.defaults(), // Or custom config
/// )
/// ```
class ActivityHeatMap extends StatelessWidget {
  /// Date → minutes of activity
  final Map<DateTime, double> data;

  /// Configuration for thresholds and colors (optional)
  final AnalysisConfig config;

  const ActivityHeatMap({super.key, required this.data, AnalysisConfig? config})
    : config =
          config ??
          const AnalysisConfig(
            heatmapThresholds: {
              1: AppColors.heatmapLight,
              30: AppColors.heatmapMedium,
              60: AppColors.heatmapDark,
              120: AppColors.heatmapDeep,
            },
            categoryColors: {},
          );

  @override
  Widget build(BuildContext context) {
    return HeatMapCalendar(
      datasets: _normalizeDates(data),
      colorMode: ColorMode.color,
      defaultColor: config.heatmapDefaultColor,
      textColor: AppColors.black,
      showColorTip: false,
      size: 18,
      colorsets: _buildColorsets(),
    );
  }

  /// Build colorsets from config thresholds
  Map<int, Color> _buildColorsets() {
    final Map<int, Color> colorsets = {};
    for (final entry in config.heatmapThresholds.entries) {
      colorsets[entry.key] = entry.value;
    }
    return colorsets;
  }

  /// Normalize dates (heatmap package needs dates without time component)
  Map<DateTime, int> _normalizeDates(Map<DateTime, double> raw) {
    final Map<DateTime, int> normalized = {};
    for (final entry in raw.entries) {
      final date = DateTime(entry.key.year, entry.key.month, entry.key.day);
      normalized[date] = entry.value.toInt();
    }
    return normalized;
  }
}
