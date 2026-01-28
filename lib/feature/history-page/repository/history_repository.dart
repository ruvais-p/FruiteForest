import 'package:fruiteforest/feature/history-page/model/history_item_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HistoryRepository {
  final SupabaseClient _client = Supabase.instance.client;

  /// Fetch order history with joined store item details
  Future<List<HistoryItem>> fetchOrderHistory() async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    // Query orders with JOIN to store table via "item" foreign key
    final response = await _client
        .from('orders')
        .select(
          'id, created_at, status, store:item(store_element, image_url, points)',
        )
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return (response as List).map((e) => HistoryItem.fromJson(e)).toList();
  }

  /// Calculate total points spent from order history
  Future<int> getTotalPointsSpent() async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    // Fetch all orders with their item points
    final response = await _client
        .from('orders')
        .select('store:item(points)')
        .eq('user_id', user.id);

    // Sum up all points
    int total = 0;
    for (var order in response as List) {
      if (order['store'] != null && order['store']['points'] != null) {
        total += order['store']['points'] as int;
      }
    }
    return total;
  }
}
