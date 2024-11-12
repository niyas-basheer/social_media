// verify_phone_number_usecase.dart

import 'package:test_server_app/features/app/user/domain/repository/user_repository.dart';

class VerifyPhoneNumberUseCase {
  final UserRepository repository;

  VerifyPhoneNumberUseCase({required this.repository});

  Future<String> call(String phoneNumber, String otp) async {
    // Call the repository to verify the phone number and OTP
    return await repository.verifyPhoneNumber(phoneNumber, otp);
  }

  Future<String> resendOtp(String phoneNumber) async {
    // Call the repository to resend the OTP
    return await repository.resendOtp(phoneNumber);
  }
}
