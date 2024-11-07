
import 'package:test_server_app/features/app/user/domain/repository/user_repository.dart';


class SignOutUseCase {
  final UserRepository repository;

  SignOutUseCase({required this.repository});

  Future<void> call() async {
    return repository.signOut();
  }

}