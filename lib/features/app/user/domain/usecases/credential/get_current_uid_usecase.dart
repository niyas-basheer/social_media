

import 'package:test_server_app/features/app/user/domain/repository/user_repository.dart';

class GetCurrentUidUseCase {
  final UserRepository repository;

  GetCurrentUidUseCase({required this.repository});

  Future<String> call() async {
    
    return repository.getCurrentUID();
  }

}