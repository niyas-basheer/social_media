
import 'package:test_server_app/features/status/domain/entities/status_entity.dart';

abstract class StatusRepository {

  Future<void> createStatus(StatusEntity status);
  Future<void> updateStatus(StatusEntity status);
  Future<void> updateOnlyImageStatus(StatusEntity status);
  Future<void> seenStatusUpdate(String statusId, int imageIndex,);
  Future<void> deleteStatus(StatusEntity status);
  Stream<List<StatusEntity>> getStatuses(StatusEntity status);
  Stream<List<StatusEntity>> getMyStatus();
  Future<List<StatusEntity>> getMyStatusFuture();
}