import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fruiteforest/common/services/dnd_service.dart';
import 'package:fruiteforest/feature/homepage/model/activity_category_model.dart';
import 'package:fruiteforest/feature/homepage/repository/home_repository.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _repository;
  Timer? _timer;
  StreamSubscription<int>? _pointsSub;

  HomeBloc(this._repository) : super(HomeState.initial()) {
    on<HomeStarted>(_onHomeStarted);
    on<PointsUpdated>(_onPointsUpdated);
    on<TimerStart>(_onStart);
    on<TimerTick>(_onTick);
    on<TimerGiveUp>(_onGiveUp);
    on<CategorySelected>(_onCategorySelected);
  }

  // 🔹 App/Home started
  Future<void> _onHomeStarted(
    HomeStarted event,
    Emitter<HomeState> emit,
  ) async {
    await _repository.updateLastActive();

    // 🔥 Listen to realtime points
    _pointsSub?.cancel();
    _pointsSub = _repository.pointsStream().listen((points) {
      add(PointsUpdated(points));
    });
  }

  void _onPointsUpdated(PointsUpdated event, Emitter<HomeState> emit) {
    emit(state.copyWith(points: event.points));
  }

  void _onCategorySelected(CategorySelected event, Emitter<HomeState> emit) {
    emit(state.copyWith(category: event.category));
  }

  // 🔹 START → DND ON
  Future<void> _onStart(TimerStart event, Emitter<HomeState> emit) async {
    if (state.category == null) return; // safety

    const totalSeconds = 1 * 60;
    await DndService.enableDnd();

    emit(
      state.copyWith(
        seconds: totalSeconds,
        hasStarted: true,
        isRunning: true,
        showCompletionDialog: false,
        activityStartedAt: DateTime.now(),
      ),
    );

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(TimerTick());
    });
  }

  // 🔹 TICK
  Future<void> _onTick(TimerTick event, Emitter<HomeState> emit) async {
    if (state.seconds <= 1) {
      _timer?.cancel();
      await DndService.disableDnd();

      // ✅ Insert activity log
      if (state.activityStartedAt != null) {
        await _repository.insertActivityLog(
          startedAt: state.activityStartedAt!,
          endedAt: DateTime.now(),
          category: state.category!.value, // 👈 DB value
        );
      }

      emit(
        state.copyWith(
          seconds: 0,
          isRunning: false,
          hasStarted: false,
          showCompletionDialog: true,
          activityStartedAt: null,
        ),
      );
    } else {
      emit(state.copyWith(seconds: state.seconds - 1));
    }
  }

  // 🔹 GIVE UP → DND OFF
  Future<void> _onGiveUp(TimerGiveUp event, Emitter<HomeState> emit) async {
    _timer?.cancel();
    await DndService.disableDnd();

    emit(state.copyWith(isRunning: false, hasStarted: false, seconds: 0));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _pointsSub?.cancel();
    DndService.disableDnd();
    return super.close();
  }
}
