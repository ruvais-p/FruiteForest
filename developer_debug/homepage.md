# ⏱️ Homepage Feature Documentation

## File Structure

```
lib/feature/homepage/
├── bloc/
│   ├── home_bloc.dart      # Timer & session logic
│   ├── home_event.dart     # Timer control events
│   └── home_state.dart     # Timer state
├── model/
│   ├── activity_category_model.dart  # Category enum
│   └── activity_log_model.dart       # Activity log entity
├── presentation/
│   ├── home_page.dart      # Main home screen
│   └── widget/
│       └── timer_widget.dart # Countdown display
└── repository/
    └── home_repository.dart # Database operations
```

---

## Classes & Functions

### HomeBloc (`home_bloc.dart`)

| Function              | Purpose                              |
| --------------------- | ------------------------------------ |
| `_onHomeStarted`      | Initialize page, start points stream |
| `_onCategorySelected` | Store selected activity category     |
| `_onStart`            | Start timer, enable DND mode         |
| `_onTick`             | Countdown tick (every second)        |
| `_onGiveUp`           | Cancel session, disable DND          |
| `_onPointsUpdated`    | Update points from real-time stream  |
| `close()`             | Cleanup: cancel timer, subscription  |

### HomeRepository (`home_repository.dart`)

| Function                 | Purpose                       |
| ------------------------ | ----------------------------- |
| `updateLastActive()`     | Track user activity timestamp |
| `pointsStream()`         | Real-time points subscription |
| `insertActivityLog(...)` | Record completed session      |

### ActivityCategory (`activity_category_model.dart`)

```dart
enum ActivityCategory { focus, study, gym, reading }

extension ActivityCategoryX on ActivityCategory {
  String get label => ...  // UI display name
  String get value => ...  // Database value
}
```

---

## Timer Flow

```
┌──────────────┐
│ Select Category │
└───────┬──────┘
        │ CategorySelected
        ▼
┌──────────────┐
│ Press Start  │
└───────┬──────┘
        │ TimerStart
        ▼
┌──────────────┐
│ DND Enabled  │ ← Device enters Do Not Disturb
│ Timer: 25:00 │
└───────┬──────┘
        │ TimerTick (every second)
        ▼
   ┌────┴────┐
   │ 00:00?  │
   └────┬────┘
   No   │   Yes
   ↓    │    ↓
Continue  Complete
        │
        ▼
┌──────────────┐
│ Log Activity │ ← Insert to database
│ Award Points │ ← Via database trigger
│ Disable DND  │
└──────────────┘
```

---

## Debugging

### Timer Not Starting

1. Check category is selected (not null)
2. Verify DND permission granted
3. Check console for errors

### Points Not Updating

1. Verify `points` table has real-time enabled in Supabase
2. Check subscription is active in bloc
3. Test RPC manually in Supabase SQL editor

### DND Not Working

1. Android only - iOS doesn't support programmatic DND
2. Check notification access in device settings
3. Test `DndService.enableDnd()` manually

---

## Configuration

### Change Timer Duration

In `home_bloc.dart`, `_onStart` function:

```dart
// Current: 25 minutes
final totalSeconds = 25 * 60;

// Change to 15 minutes:
final totalSeconds = 15 * 60;
```

### Add New Category

1. Add to enum in `activity_category_model.dart`:

```dart
enum ActivityCategory { focus, study, gym, reading, meditation }
```

2. Add label in extension:

```dart
case ActivityCategory.meditation: return 'Meditation';
```

3. Add color in `colors.dart`:

```dart
static const Color categoryMeditation = Color(0xFFE1BEE7);
```

4. Add to `AnalysisConfig` in `analysis_config.dart`

---

## Future Modifications

### Variable Timer Durations

- Add `selectedDuration` to `HomeState`
- Add `DurationSelected` event
- Let user pick 15/25/45/60 minutes

### Background Timer

- Use `flutter_background_service` package
- Keep timer running when app is backgrounded

### Timer Sound/Notification

- Add sound when timer completes
- Show notification even when app is closed
