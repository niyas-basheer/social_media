

import 'package:test_server_app/features/call/domain/entities/call_entity.dart';
import 'package:test_server_app/features/call/domain/repository/call_repository.dart';

class GetMyCallHistoryUseCase {

  final CallRepository repository;

  const GetMyCallHistoryUseCase({required this.repository});

  Stream<List<CallEntity>> call(String uid)  {
    return repository.getMyCallHistory();
  }
}