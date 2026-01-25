# Analysis Page Documentation

The analysis page displays user activity analytics with two main visualizations:

1. **Activity Heatmap** - Calendar showing daily engagement intensity
2. **Category Distribution** - Pie chart showing time spent per category

## File Structure

```
lib/feature/analysis_page/
├── bloc/
│   ├── analysis_bloc.dart    # Fetches data from Supabase
│   ├── analysis_event.dart
│   └── analysis_state.dart
├── config/
│   └── analysis_config.dart  # ⭐ Configurable thresholds & colors
├── model/
│   └── heat_map_cell_model.dart
├── presentation/
│   ├── analysis_page.dart    # Main page layout
│   └── widgets/
│       ├── activity_heat_map_widget.dart
│       └── category_pie_chart_widget.dart
└── repository/
    └── analysis_repository.dart
```

---

## Configuring Thresholds

All thresholds are in `config/analysis_config.dart`:

### Heatmap Thresholds

```dart
// In analysis_config.dart
AnalysisConfig(
  heatmapThresholds: {
    1: AppColors.heatmapLight,    // Any activity (1+ min)
    30: AppColors.heatmapMedium,  // 30+ minutes
    60: AppColors.heatmapDark,    // 1+ hour
    120: AppColors.heatmapDeep,   // 2+ hours (heavy focus)
  },
)
```

**To make it more sensitive** (show activity at lower thresholds):

```dart
heatmapThresholds: {
  1: AppColors.heatmapLight,
  15: AppColors.heatmapMedium,   // Changed from 30
  30: AppColors.heatmapDark,     // Changed from 60
  60: AppColors.heatmapDeep,     // Changed from 120
}
```

### Category Colors

```dart
categoryColors: {
  'Gym': AppColors.categoryGym,       // Yellow/Gold
  'Focus': AppColors.categoryFocus,   // Light Blue
  'Reading': AppColors.categoryReading, // Pink
}
```

**To add a new category:**

1. Add color in `lib/common/theme/colors/colors.dart`
2. Add mapping in `AnalysisConfig.defaults()`

---

## Using Custom Config

```dart
// In analysis_page.dart or where you navigate to it
AnalysisPage(
  config: AnalysisConfig(
    heatmapThresholds: {
      1: Colors.green.shade100,
      20: Colors.green.shade300,
      40: Colors.green.shade500,
      80: Colors.green.shade700,
    },
    categoryColors: {
      'Gym': Colors.orange,
      'Focus': Colors.blue,
      'Reading': Colors.purple,
    },
  ),
)
```

---

## Data Flow

```
Supabase RPCs
     │
     ▼
AnalysisBloc._onLoadAnalysis()
     │
     ├── get_category_minutes → categoryMinutes
     └── get_daily_minutes → dailyMinutes
     │
     ▼
AnalysisState
     │
     ▼
AnalysisPage (BlocBuilder)
     │
     ├── ActivityHeatMap(data, config)
     └── CategoryPieChart(data, config)
```

---

## Supabase RPC Requirements

The bloc expects these RPCs:

### `get_category_minutes(p_uid)`

Returns: `[{ category: string, minutes: number }]`

### `get_daily_minutes(p_uid)`

Returns: `[{ day: string (date), minutes: number }]`

---

## Theme Integration

All colors use `AppColors` from `lib/common/theme/colors/colors.dart`:

- Heatmap: `heatmapLight`, `heatmapMedium`, `heatmapDark`, `heatmapDeep`
- Categories: `categoryGym`, `categoryFocus`, `categoryReading`

All text uses `AppTextTheme` from `lib/common/theme/text_theme/text_theme.dart`:

- Section headers: `titleLarge`
- Labels: `bodyMedium`, `labelMedium`

---

## Dependencies

- `fl_chart` - Pie chart
- `flutter_heatmap_calendar` - Heatmap calendar
