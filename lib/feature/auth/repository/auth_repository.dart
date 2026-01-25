import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _client;
  AuthRepository(this._client);

  Future<void> sendOtp(String phone) async {
    // Format phone number with country code for India
    final formattedPhone = '+91$phone';
    await _client.auth.signInWithOtp(phone: formattedPhone);
  }

  Future<void> verifyOtp({required String phone, required String otp}) async {
    await _client.auth.verifyOTP(phone: phone, token: otp, type: OtpType.sms);
  }

  Future<int> resolveUserFlow() async {
    final session = _client.auth.currentSession;

    if (session == null) return 0;

    final uid = session.user.id;

    final response = await _client
        .from('profiles')
        .select('uid')
        .eq('uid', uid)
        .maybeSingle();

    if (response == null) return 1;

    return 2;
  }

  Future<void> createProfile({
    required String name,
    required int age,
    required String gender,
    required String profession,
    required String purpose,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    await _client.from('profiles').insert({
      'uid': user.id,
      'phone': user.phone,
      'name': name,
      'age': age,
      'gender': gender,
      'profession': profession,
      'purpose': purpose,
    });
  }
}
