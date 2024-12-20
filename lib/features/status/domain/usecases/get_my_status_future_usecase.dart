

import 'package:test_server_app/features/status/domain/entities/status_entity.dart';
import 'package:test_server_app/features/status/domain/repository/status_repository.dart';

class GetMyStatusFutureUseCase {

  final StatusRepository repository;

  const GetMyStatusFutureUseCase({required this.repository});

  Future<List<StatusEntity>> call() async {
    return repository.getMyStatusFuture();
  }
}