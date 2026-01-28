import 'package:bloc/bloc.dart';
import 'package:fruiteforest/feature/history-page/model/history_item_model.dart';
import 'package:meta/meta.dart';
import '../repository/history_repository.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final HistoryRepository repository;

  HistoryBloc(this.repository) : super(HistoryInitial()) {
    on<LoadHistory>(_onLoadHistory);
  }

  Future<void> _onLoadHistory(
    LoadHistory event,
    Emitter<HistoryState> emit,
  ) async {
    emit(HistoryLoading());
    try {
      final items = await repository.fetchOrderHistory();
      final totalSpent = await repository.getTotalPointsSpent();
      emit(HistoryLoaded(items: items, totalSpent: totalSpent));
    } catch (e) {
      emit(HistoryError('Failed to load history: ${e.toString()}'));
    }
  }
}
