part of 'home_bloc.dart';

@immutable
abstract class HomeState {
  final int seconds;
  final bool isRunning;

  const HomeState({required this.seconds, required this.isRunning});

  HomeState copyWith({int? seconds, bool? isRunning});
}

/* ───────────── INITIAL ───────────── */
class HomeInitial extends HomeState {
  const HomeInitial() : super(seconds: 0, isRunning: false);

  @override
  HomeState copyWith({int? seconds, bool? isRunning}) {
    return HomeRunning(
      seconds: seconds ?? this.seconds,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}

/* ───────────── RUNNING ───────────── */
class HomeRunning extends HomeState {
  const HomeRunning({required super.seconds, required super.isRunning});

  @override
  HomeState copyWith({int? seconds, bool? isRunning}) {
    return HomeRunning(
      seconds: seconds ?? this.seconds,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}
