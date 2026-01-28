part of 'history_bloc.dart';

@immutable
sealed class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<HistoryItem> items;
  final int totalSpent;

  HistoryLoaded({required this.items, required this.totalSpent});
}

class HistoryError extends HistoryState {
  final String message;
  HistoryError(this.message);
}
