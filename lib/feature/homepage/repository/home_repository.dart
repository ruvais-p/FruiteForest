import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeRepository {
  SupabaseClient get _client => Supabase.instance.client;

  Future<void> updateLastActive() async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    await _client
        .from('profiles')
        .update({'last_active_at': DateTime.now().toUtc().toIso8601String()})
        .eq('uid', user.id);
  }

  /// 🔹 Realtime points stream
  Stream<int> pointsStream() {
    final user = _client.auth.currentUser;
    if (user == null) {
      return const Stream.empty();
    }

    return _client
        .from('points')
        .stream(primaryKey: ['uid'])
        .eq('uid', user.id)
        .map((rows) {
          if (rows.isEmpty) return 0;
          return rows.first['point'] as int;
        });
  }

  Future<void> insertActivityLog({
    required DateTime startedAt,
    required DateTime endedAt,
    required String category,
  }) async {
    final uid = _client.auth.currentUser!.id;

    await _client.from('activity_log').insert({
      'uid': uid,
      'started_at': startedAt.toIso8601String(),
      'ended_at': endedAt.toIso8601String(),
      'category': category,
    });
  }
}
