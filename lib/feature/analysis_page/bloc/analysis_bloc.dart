import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'analysis_event.dart';
part 'analysis_state.dart';

class AnalysisBloc extends Bloc<AnalysisEvent, AnalysisState> {
  final SupabaseClient client;

  AnalysisBloc(this.client) : super(AnalysisState.initial()) {
    on<LoadAnalysis>(_onLoadAnalysis);
  }

  Future<void> _onLoadAnalysis(
    LoadAnalysis event,
    Emitter<AnalysisState> emit,
  ) async {
    emit(state.copyWith(loading: true));

    final uid = client.auth.currentUser!.id;

    // Pie data
    final pieRes = await client.rpc(
      'get_category_minutes',
      params: {'p_uid': uid},
    );

    // Heatmap data
    final heatRes = await client.rpc(
      'get_daily_minutes',
      params: {'p_uid': uid},
    );

    final categoryMap = <String, double>{};
    for (final row in pieRes) {
      categoryMap[row['category']] = (row['minutes'] as num).toDouble();
    }

    final dailyMap = <DateTime, double>{};
    for (final row in heatRes) {
      dailyMap[DateTime.parse(row['day'])] = (row['minutes'] as num).toDouble();
    }

    emit(
      state.copyWith(
        loading: false,
        categoryMinutes: categoryMap,
        dailyMinutes: dailyMap,
      ),
    );
  }
}
