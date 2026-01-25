import 'package:flutter/material.dart';
import 'package:fruiteforest/common/theme/colors/colors.dart';

/// Configuration for the Analysis page charts.
///
/// This class provides configurable thresholds for heatmap intensity levels
/// and category colors for the pie chart. You can customize these values
/// to adjust how data is visualized.
///
/// ## Example Usage:
/// ```dart
/// // Use defaults
/// final config = AnalysisConfig.defaults();
///
/// // Or customize thresholds
/// final customConfig = AnalysisConfig(
///   heatmapThresholds: {
///     1: Colors.green.shade100,
///     15: Colors.green.shade300,  // Lower threshold = more sensitive
///     45: Colors.green.shade500,
///     90: Colors.green.shade700,
///   },
///   categoryColors: {
///     'Gym': Colors.amber,
///     'Focus': Colors.blue,
///     'Reading': Colors.pink,
///   },
/// );
/// ```
class AnalysisConfig {
  /// Heatmap thresholds: minutes → color
  ///
  /// Keys represent minimum minutes for that color level.
  /// Higher keys = more intense colors for longer durations.
  ///
  /// **Default thresholds:**
  /// - 1 min  → Light (any activity)
  /// - 30 min → Medium
  /// - 60 min → Dark
  /// - 120 min → Deep (heavy focus)
  final Map<int, Color> heatmapThresholds;

  /// Category name → color mapping for pie chart
  ///
  /// Keys should match category names from Supabase.
  final Map<String, Color> categoryColors;

  /// Default color for heatmap cells with no data
  final Color heatmapDefaultColor;

  const AnalysisConfig({
    required this.heatmapThresholds,
    required this.categoryColors,
    this.heatmapDefaultColor = const Color(0xFFE0E0E0),
  });

  /// Default configuration with sensible thresholds
  factory AnalysisConfig.defaults() => AnalysisConfig(
    heatmapThresholds: {
      1: AppColors.heatmapLight,
      30: AppColors.heatmapMedium,
      60: AppColors.heatmapDark,
      120: AppColors.heatmapDeep,
    },
    categoryColors: {
      'Gym': AppColors.categoryGym,
      'Focus': AppColors.categoryFocus,
      'Reading': AppColors.categoryReading,
    },
  );

  /// Get color for given minutes based on thresholds
  Color getHeatmapColor(int minutes) {
    if (minutes <= 0) return heatmapDefaultColor;

    Color result = heatmapDefaultColor;
    for (final entry in heatmapThresholds.entries) {
      if (minutes >= entry.key) {
        result = entry.value;
      }
    }
    return result;
  }

  /// Get color for a category, with fallback
  Color getCategoryColor(String category) {
    return categoryColors[category] ?? AppColors.gray;
  }
}
