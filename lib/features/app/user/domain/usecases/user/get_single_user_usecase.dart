

import 'package:test_server_app/features/app/user/data/models/user_model.dart';

import 'package:test_server_app/features/app/user/domain/repository/user_repository.dart';

class GetSingleUserUseCase {
  final UserRepository repository;

  GetSingleUserUseCase({required this.repository});

  Stream<UserModel> call(String uid) {
    return repository.getSingleUser(uid);
  }

}