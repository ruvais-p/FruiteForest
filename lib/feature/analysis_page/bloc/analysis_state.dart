part of 'analysis_bloc.dart';

@immutable
@immutable
class AnalysisState {
  final bool loading;
  final Map<String, double> categoryMinutes;
  final Map<DateTime, double> dailyMinutes;

  const AnalysisState({
    required this.loading,
    required this.categoryMinutes,
    required this.dailyMinutes,
  });

  factory AnalysisState.initial() =>
      const AnalysisState(loading: true, categoryMinutes: {}, dailyMinutes: {});

  AnalysisState copyWith({
    bool? loading,
    Map<String, double>? categoryMinutes,
    Map<DateTime, double>? dailyMinutes,
  }) {
    return AnalysisState(
      loading: loading ?? this.loading,
      categoryMinutes: categoryMinutes ?? this.categoryMinutes,
      dailyMinutes: dailyMinutes ?? this.dailyMinutes,
    );
  }
}
