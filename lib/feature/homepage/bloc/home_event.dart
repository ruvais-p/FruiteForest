part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {
  const HomeEvent();
}

class TimerStart extends HomeEvent {
  const TimerStart();
}

class TimerPause extends HomeEvent {
  const TimerPause();
}

class TimerStop extends HomeEvent {
  const TimerStop();
}

class TimerTick extends HomeEvent {
  const TimerTick();
}
