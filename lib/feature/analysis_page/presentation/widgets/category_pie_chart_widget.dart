import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fruiteforest/feature/homepage/model/activity_category_model.dart';

/// Donut-style Pie Chart with Category Labels
///
/// Displays category distribution as a donut chart with labels
/// directly on each section. Uses ActivityCategory for consistent colors.
class CategoryPieChart extends StatelessWidget {
  final Map<String, double> data;

  const CategoryPieChart({super.key, required this.data});

  // Category colors matching ActivityCategory enum
  // Keys match ActivityCategory.name (focus, study, gym, reading)
  static const Map<String, Color> categoryColors = {
    'focus': Color(0xFFE8956F), // Coral/Orange
    'study': Color(0xFF9B8DD6), // Purple
    'gym': Color(0xFF7DD3D8), // Cyan/Teal
    'reading': Color(0xFFE88BA0), // Pink
  };

  // Fallback colors for any other categories
  static const List<Color> fallbackColors = [
    Color(0xFF6B8DD6), // Blue
    Color(0xFF6BD69B), // Green
    Color(0xFFD6B86B), // Gold
    Color(0xFFD66B8D), // Rose
  ];

  // Display labels for categories
  static String getCategoryLabel(String key) {
    // Try to match with ActivityCategory for proper label
    try {
      final category = ActivityCategory.values.firstWhere((e) => e.name == key);
      return category.label;
    } catch (_) {
      // Fallback: capitalize first letter
      if (key.isEmpty) return 'Unknown';
      return key[0].toUpperCase() + key.substring(1);
    }
  }

  // Get color for a category key
  static Color getColorForCategory(String key, int index) {
    if (categoryColors.containsKey(key)) {
      return categoryColors[key]!;
    }
    return fallbackColors[index % fallbackColors.length];
  }

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(
        child: Text(
          'No activity data yet',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return PieChart(
      PieChartData(
        sectionsSpace: 3,
        centerSpaceRadius: 50, // Creates donut hole
        sections: _buildSections(),
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            // Optional: Add touch handling for interactivity
          },
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildSections() {
    final entries = data.entries.toList();

    return entries.asMap().entries.map((mapEntry) {
      final index = mapEntry.key;
      final entry = mapEntry.value;
      final color = getColorForCategory(entry.key, index);
      final label = getCategoryLabel(entry.key);

      return PieChartSectionData(
        value: entry.value,
        title: label,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [Shadow(color: Colors.black38, blurRadius: 3)],
        ),
        radius: 80,
        color: color,
        titlePositionPercentageOffset: 0.55,
      );
    }).toList();
  }
}
