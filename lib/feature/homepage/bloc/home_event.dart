part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class HomeStarted extends HomeEvent {}

class TimerStart extends HomeEvent {}

class TimerTick extends HomeEvent {}

class TimerGiveUp extends HomeEvent {}

class PointsUpdated extends HomeEvent {
  final int points;
  PointsUpdated(this.points);
}
class CategorySelected extends HomeEvent {
  final ActivityCategory category;
  CategorySelected(this.category);
}
