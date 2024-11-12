// presentation/cubit/login_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_server_app/features/app/user/domain/entities/otp_entity.dart';
import 'package:test_server_app/features/app/user/domain/usecases/credential/send_otp_usecase.dart';

class LoginCubit extends Cubit<LoginState> {
  final SendOtpUseCase sendOtpUseCase;

  LoginCubit({required this.sendOtpUseCase}) : super(LoginInitial());

  Future<void> sendOtp(String phoneNumber) async {
    emit(LoginLoading());
    try {
      final OTPResponse response = await sendOtpUseCase(phoneNumber);
      if (response.message == 'OTP sent successfully.') {
        emit(LoginOtpSent());
      } else {
        emit(LoginFailure("Failed to send OTP"));
      }
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}

abstract class LoginState {}

class LoginInitial extends LoginState {}
class LoginLoading extends LoginState {}
class LoginOtpSent extends LoginState {}
class LoginFailure extends LoginState {
  final String message;
  LoginFailure(this.message);
}
