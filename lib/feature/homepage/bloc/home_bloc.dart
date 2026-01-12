import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:fruiteforest/common/services/dnd_service.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  Timer? _timer;

  HomeBloc() : super( HomeInitial()) {
    on<TimerStart>(_onStart);
    on<TimerPause>(_onPause);
    on<TimerStop>(_onStop);
    on<TimerTick>(_onTick);
  }

  /* ───────────────── START ───────────────── */
  Future<void> _onStart(
    TimerStart event,
    Emitter<HomeState> emit,
  ) async {
    if (state.isRunning) return;

    // 🔕 Enable Do Not Disturb
    await DndService.enableDnd();

    emit(
      state.copyWith(
        isRunning: true,
      ),
    );

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => add( TimerTick()),
    );
  }

  /* ───────────────── PAUSE ───────────────── */
  Future<void> _onPause(
    TimerPause event,
    Emitter<HomeState> emit,
  ) async {
    _timer?.cancel();
    _timer = null;

    // 🔔 Disable DND (optional)
    await DndService.disableDnd();

    emit(
      state.copyWith(
        isRunning: false,
      ),
    );
  }

  /* ───────────────── STOP ───────────────── */
  Future<void> _onStop(
    TimerStop event,
    Emitter<HomeState> emit,
  ) async {
    _timer?.cancel();
    _timer = null;

    // 🔔 Disable DND
    await DndService.disableDnd();

    emit(
      state.copyWith(
        seconds: 0,
        isRunning: false,
      ),
    );
  }

  /* ───────────────── TICK ───────────────── */
  void _onTick(
    TimerTick event,
    Emitter<HomeState> emit,
  ) {
    emit(
      state.copyWith(
        seconds: state.seconds + 1,
      ),
    );
  }

  /* ───────────────── DISPOSE ───────────────── */
  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
