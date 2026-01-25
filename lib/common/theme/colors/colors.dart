import 'package:flutter/animation.dart';

class AppColors {
  // Core theme colors
  static const Color yellow = Color(0xFFF0AC5B);
  static const Color black = Color(0xFF000000);
  static const Color gray = Color(0xFF888888);
  static const Color backgroundColor = Color(0xFFFFFFFF);

  // Heatmap gradient (orange tones matching yellow theme)
  static const Color heatmapLight = Color(0xFFFFF3E0);
  static const Color heatmapMedium = Color(0xFFFFCC80);
  static const Color heatmapDark = Color(0xFFF0AC5B); // Same as yellow
  static const Color heatmapDeep = Color(0xFFE65100);

  // Pie chart category colors
  static const Color categoryGym = Color(0xFFF0AC5B); // Yellow/Gold
  static const Color categoryFocus = Color(0xFF90CAF9); // Light Blue
  static const Color categoryReading = Color(0xFFF48FB1); // Pink
}
