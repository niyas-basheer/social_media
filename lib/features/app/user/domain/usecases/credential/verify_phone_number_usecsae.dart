

import 'package:test_server_app/features/app/user/domain/repository/user_repository.dart';

class VerifyPhoneNumberUseCase {
  final UserRepository repository;

  VerifyPhoneNumberUseCase({required this.repository});

  Future<void> call(String phoneNumber) async {
    return repository.verifyPhoneNumber(phoneNumber);
  }

}