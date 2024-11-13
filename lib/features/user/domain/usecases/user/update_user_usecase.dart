
import 'package:test_server_app/features/user/data/models/user_model.dart';
import 'package:test_server_app/features/user/domain/repository/user_repository.dart';

class UpdateUserUseCase {
  final UserRepository repository;

  UpdateUserUseCase({required this.repository});

  Future<void> call(UserModel user) async {
    return repository.updateUser(user);
  }

}