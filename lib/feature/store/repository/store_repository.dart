import 'package:fruiteforest/feature/store/model/order_model.dart';
import 'package:fruiteforest/feature/store/model/shipping_address_model.dart';
import 'package:fruiteforest/feature/store/model/store_items_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StoreRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<StoreItem>> fetchStoreItems() async {
    final response = await _client.from('store').select().order('created_at');

    return (response as List).map((e) => StoreItem.fromJson(e)).toList();
  }

  Future<void> buyItem(String itemId) async {
    await _client.rpc('buy_store_item', params: {'p_item_id': itemId});
  }

  /// Get the current user's points
  Future<int> getUserPoints() async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final response = await _client
        .from('points')
        .select('point')
        .eq('uid', user.id)
        .maybeSingle();

    if (response == null) return 0;
    return response['point'] as int;
  }

  /// Check if the current user has a shipping address
  Future<ShippingAddress?> checkShippingAddress() async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final response = await _client
        .from('shipping_addresses')
        .select()
        .eq('uid', user.id)
        .maybeSingle();

    if (response == null) return null;
    return ShippingAddress.fromJson(response);
  }

  /// Add a shipping address for the current user
  Future<ShippingAddress> addShippingAddress({
    required String address,
    required String state,
    required String district,
    required String postOffice,
    required String postPin,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final response = await _client
        .from('shipping_addresses')
        .insert({
          'uid': user.id,
          'address': address,
          'state': state,
          'district': district,
          'post_office': postOffice,
          'post_pin': postPin,
        })
        .select()
        .single();

    return ShippingAddress.fromJson(response);
  }

  /// Update the shipping address for the current user
  Future<ShippingAddress> updateShippingAddress({
    required String address,
    required String state,
    required String district,
    required String postOffice,
    required String postPin,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final response = await _client
        .from('shipping_addresses')
        .update({
          'address': address,
          'state': state,
          'district': district,
          'post_office': postOffice,
          'post_pin': postPin,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('uid', user.id)
        .select()
        .single();

    return ShippingAddress.fromJson(response);
  }

  /// Get the current user's shipping address
  Future<ShippingAddress?> getShippingAddress() async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final response = await _client
        .from('shipping_addresses')
        .select()
        .eq('uid', user.id)
        .maybeSingle();

    if (response == null) return null;
    return ShippingAddress.fromJson(response);
  }

  /// Create an order for the user and deduct points
  Future<Order> createOrder(String itemId, int itemPoints) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    // First check if address exists
    final address = await checkShippingAddress();
    if (address == null) {
      throw Exception('Shipping address not found');
    }

    // Create the order
    final response = await _client
        .from('orders')
        .insert({'user_id': user.id, 'item': itemId, 'status': 'pending'})
        .select()
        .single();

    // Deduct points from user's account
    final currentPoints = await getUserPoints();
    final newPoints = currentPoints - itemPoints;

    await _client
        .from('points')
        .update({
          'point': newPoints,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('uid', user.id);

    return Order.fromJson(response);
  }
}
