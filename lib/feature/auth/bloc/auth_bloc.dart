import 'package:bloc/bloc.dart';
import 'package:fruiteforest/feature/auth/repository/auth_repository.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthInitial()) {
    on<SendOtpEvent>(_sendOtp);
    on<VerifyOtpEvent>(_verifyOtp);
    on<CheckAuthStatusEvent>(_checkAuthStatus);
    on<CreateProfileEvent>(_createProfile);
  }

  Future<void> _sendOtp(SendOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await repository.sendOtp(event.phone);
      emit(OtpSentSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _verifyOtp(VerifyOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await repository.verifyOtp(phone: event.phone, otp: event.otp);
      final flow = await repository.resolveUserFlow();
      emit(AuthSuccess(flow));
    } catch (e) {
      emit(AuthError("Invalid OTP"));
    }
  }

  Future<void> _checkAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    final flow = await repository.resolveUserFlow();
    emit(AuthSuccess(flow));
  }

  Future<void> _createProfile(
    CreateProfileEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await repository.createProfile(
        name: event.name,
        age: event.age,
        gender: event.gender,
        profession: event.profession,
        purpose: event.purpose,
      );
      emit(ProfileCreatedSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
