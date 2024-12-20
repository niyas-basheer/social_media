
import 'package:test_server_app/features/status/domain/entities/status_entity.dart';
import 'package:test_server_app/features/status/domain/repository/status_repository.dart';

class GetMyStatusUseCase {

  final StatusRepository repository;

  const GetMyStatusUseCase({required this.repository});

  Stream<List<StatusEntity>> call() {
    return repository.getMyStatus();
  }
}