

import 'package:test_server_app/features/user/data/models/user_model.dart';

import 'package:test_server_app/features/user/domain/repository/user_repository.dart';

class GetSingleUserUseCase {
  final UserRepository repository;

  GetSingleUserUseCase({required this.repository});

  Stream<UserModel> call(uid) {
    return repository.getSingleUser(uid);
  }

}