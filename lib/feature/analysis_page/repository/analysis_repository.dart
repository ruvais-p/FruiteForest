import 'package:fruiteforest/feature/analysis_page/model/heat_map_cell_model.dart';
import 'package:fruiteforest/feature/homepage/model/activity_category_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AnalysisRepository {
  final SupabaseClient _client;
  AnalysisRepository(this._client);

  // 🔹 Pie diagram data
  Future<Map<ActivityCategory, int>> getCategoryStats() async {
    final res = await _client.rpc('category_stats'); // OR raw SQL

    final Map<ActivityCategory, int> result = {};
    for (final row in res) {
      result[
        ActivityCategory.values.firstWhere(
          (e) => e.value == row['category'],
        )
      ] = row['minutes'];
    }
    return result;
  }

  // 🔹 Heatmap data
  Future<List<HeatMapCell>> getHeatMap() async {
    final res = await _client.rpc('activity_heatmap');

    return res.map<HeatMapCell>((e) {
      return HeatMapCell(
        day: DateTime.parse(e['day']),
        hour: e['hour'],
        minutes: e['minutes'],
      );
    }).toList();
  }
}
