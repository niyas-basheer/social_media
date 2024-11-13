import 'package:test_server_app/features/status/domain/entities/status_entity.dart';
import 'package:test_server_app/features/status/domain/repository/status_repository.dart';
class UpdateStatusUseCase {

  final StatusRepository repository;

  const UpdateStatusUseCase({required this.repository});

  Future<void> call(StatusEntity status) async {
    return await repository.updateStatus(status);
  }
}