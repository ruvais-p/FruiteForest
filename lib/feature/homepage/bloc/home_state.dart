part of 'home_bloc.dart';

@immutable
class HomeState {
  final int seconds;
  final bool hasStarted;
  final bool isRunning;
  final bool showCompletionDialog;
  final int points;
  final DateTime? activityStartedAt;
  final ActivityCategory? category; // 👈 NEW

  const HomeState({
    required this.seconds,
    required this.hasStarted,
    required this.isRunning,
    required this.showCompletionDialog,
    required this.points,
    this.activityStartedAt,
    this.category,
  });

  factory HomeState.initial() {
    return const HomeState(
      seconds: 0,
      hasStarted: false,
      isRunning: false,
      showCompletionDialog: false,
      points: 0,
      activityStartedAt: null,
      category: null,
    );
  }

  HomeState copyWith({
    int? seconds,
    bool? hasStarted,
    bool? isRunning,
    bool? showCompletionDialog,
    int? points,
    DateTime? activityStartedAt,
    ActivityCategory? category,
  }) {
    return HomeState(
      seconds: seconds ?? this.seconds,
      hasStarted: hasStarted ?? this.hasStarted,
      isRunning: isRunning ?? this.isRunning,
      showCompletionDialog: showCompletionDialog ?? this.showCompletionDialog,
      points: points ?? this.points,
      activityStartedAt:
          activityStartedAt ?? this.activityStartedAt,
      category: category ?? this.category,
    );
  }
}
