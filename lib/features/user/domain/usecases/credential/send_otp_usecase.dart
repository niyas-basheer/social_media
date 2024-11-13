// domain/usecases/send_otp_use_case.dart
import 'package:test_server_app/features/user/domain/entities/otp_entity.dart';
import 'package:test_server_app/features/user/domain/repository/user_repository.dart';



class SendOtpUseCase {
  final UserRepository repository;

  SendOtpUseCase({required this.repository,});

  Future<OTPResponse> call(String phoneNumber) async {
    return await repository.sendOtp(phoneNumber);
  }
}
