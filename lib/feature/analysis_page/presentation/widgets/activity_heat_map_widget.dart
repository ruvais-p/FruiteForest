import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class ActivityHeatMap extends StatelessWidget {
  /// Date → minutes
  final Map<DateTime, double> data;

  const ActivityHeatMap({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return HeatMapCalendar(
      datasets: _normalizeDates(data),
      colorMode: ColorMode.color,
      defaultColor: Colors.grey.shade200,
      textColor: Colors.black,
      showColorTip: false,
      size: 18,
      colorsets: const {
        1: Color(0xFFC8E6C9), // light
        30: Color(0xFF81C784),
        60: Color(0xFF4CAF50),
        120: Color(0xFF1B5E20), // heavy focus
      },
    );
  }

  /// 🔑 Heatmap package needs normalized dates (no time)
  Map<DateTime, int> _normalizeDates(Map<DateTime, double> raw) {
    final Map<DateTime, int> normalized = {};
    for (final entry in raw.entries) {
      final date = DateTime(entry.key.year, entry.key.month, entry.key.day);
      normalized[date] = entry.value.toInt();
    }
    return normalized;
  }
}
