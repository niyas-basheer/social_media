// credential_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_server_app/features/app/user/domain/usecases/credential/verify_phone_number_usecsae.dart';
import 'package:test_server_app/features/app/user/presentation/cubit/credential/credential_state.dart';




class CredentialCubit extends Cubit<CredentialState> {
  final VerifyPhoneNumberUseCase verifyPhoneNumberUseCase;

  

  // Constructor accepting the use case as a dependency
  CredentialCubit({
    required this.verifyPhoneNumberUseCase,
  }) : super(CredentialInitial());

  // Method for verifying OTP
  Future<void> verifyOtp(String phoneNumber, String otp) async {
    emit(CredentialLoading());
    try {
      final result = await verifyPhoneNumberUseCase.call( phoneNumber, otp);
      if (result == 'Login successful') {
        emit(CredentialSuccess("Login successful"));
      } else {
        emit(CredentialFailure(result));
      }
    } catch (e) {
      emit(CredentialFailure(e.toString()));
    }
  }

  // Method for resending OTP
  Future<void> resendOtp(String phoneNumber) async {
    emit(CredentialLoading());
    try {
      final result = await verifyPhoneNumberUseCase.resendOtp(phoneNumber);
      if (result == 'OTP sent successfully') {
        // Optional: Notify the user of OTP sent success
        emit(CredentialSuccess("OTP sent successfully"));
      } else {
        emit(CredentialFailure('Failed to resend OTP'));
      }
    } catch (e) {
      emit(CredentialFailure("Failed to resend OTP. Please try again."));
    }
  }
}
