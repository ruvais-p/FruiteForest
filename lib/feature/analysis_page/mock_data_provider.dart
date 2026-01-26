/// Mock Data Provider for Analysis Page
///
/// This file provides mock data for testing the Analysis page without
/// requiring Supabase authentication. To disable mock data, set
/// [useMockData] to false.
///
/// TO REMOVE MOCK DATA:
/// 1. Set useMockData = false
/// 2. Delete this file
/// 3. Remove import from analysis_bloc.dart

// ═══════════════════════════════════════════════════════════════════════════
// 🔧 TOGGLE THIS FLAG TO SWITCH BETWEEN MOCK AND REAL DATA
// ═══════════════════════════════════════════════════════════════════════════
const bool useMockData = false;

// ═══════════════════════════════════════════════════════════════════════════
// 🎨 HEATMAP COLOR THRESHOLDS (in minutes)
// Adjust these values to change color intensity levels
// ═══════════════════════════════════════════════════════════════════════════
class HeatmapThresholds {
  static const int low = 30; // Light orange
  static const int medium = 60; // Medium orange
  static const int high = 90; // Dark orange
  // Above high = Very intense color
}

// ═══════════════════════════════════════════════════════════════════════════
// 📅 MOCK DAILY MINUTES DATA (for Heatmap)
// ═══════════════════════════════════════════════════════════════════════════
Map<DateTime, double> getMockDailyMinutes() {
  final now = DateTime.now();
  final Map<DateTime, double> data = {};

  // Generate data for the last 3 months
  for (int i = 0; i < 90; i++) {
    final date = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: i));

    // Create varied data pattern
    double minutes = 0;
    final dayOfWeek = date.weekday;
    final dayOfMonth = date.day;

    // Weekdays have more activity
    if (dayOfWeek >= 1 && dayOfWeek <= 5) {
      if (dayOfMonth % 3 == 0) {
        minutes = 120; // High activity days
      } else if (dayOfMonth % 2 == 0) {
        minutes = 60; // Medium activity
      } else {
        minutes = 30; // Low activity
      }
    } else {
      // Weekends - variable
      minutes = (dayOfMonth % 4 == 0) ? 45 : 0;
    }

    if (minutes > 0) {
      data[date] = minutes;
    }
  }

  return data;
}

// ═══════════════════════════════════════════════════════════════════════════
// 🥧 MOCK CATEGORY MINUTES DATA (for Pie Chart)
// Uses the SAME categories as ActivityCategory enum in:
// lib/feature/homepage/model/activity_category_model.dart
// Categories: focus, study, gym, reading
// ═══════════════════════════════════════════════════════════════════════════
Map<String, double> getMockCategoryMinutes() {
  return {
    'focus': 240, // Focus sessions
    'study': 180, // Study sessions
    'gym': 150, // Gym workouts
    'reading': 120, // Reading sessions
  };
}
