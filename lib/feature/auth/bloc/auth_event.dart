part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class SendOtpEvent extends AuthEvent {
  final String phone;
  SendOtpEvent(this.phone);
}

final class VerifyOtpEvent extends AuthEvent {
  final String phone;
  final String otp;
  VerifyOtpEvent({required this.phone, required this.otp});
}

final class CheckAuthStatusEvent extends AuthEvent {}

final class CreateProfileEvent extends AuthEvent {
  final String name;
  final int age;
  final String gender;
  final String profession;
  final String purpose;

  CreateProfileEvent({
    required this.name,
    required this.age,
    required this.gender,
    required this.profession,
    required this.purpose,
  });
}
