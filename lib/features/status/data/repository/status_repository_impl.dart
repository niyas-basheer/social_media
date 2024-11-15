
import 'package:test_server_app/features/status/data/remote/status_remote_data_source.dart';
import 'package:test_server_app/features/status/domain/entities/status_entity.dart';
import 'package:test_server_app/features/status/domain/repository/status_repository.dart';

class StatusRepositoryImpl implements StatusRepository {
  final StatusRemoteDataSource remoteDataSource;

  StatusRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> createStatus(StatusEntity status) async => remoteDataSource.createStatus(status);

  @override
  Future<void> deleteStatus(StatusEntity status) async => remoteDataSource.deleteStatus(status);

  @override
  Stream<List<StatusEntity>> getMyStatus() => remoteDataSource.getMyStatus();

  @override
  Future<List<StatusEntity>> getMyStatusFuture() async => remoteDataSource.getMyStatusFuture();

  @override
  Stream<List<StatusEntity>> getStatuses(StatusEntity status) => remoteDataSource.getStatuses(status);

  @override
  Future<void> seenStatusUpdate(String statusId, int imageIndex) async => remoteDataSource.seenStatusUpdate(statusId, imageIndex);

  @override
  Future<void> updateOnlyImageStatus(StatusEntity status) async => remoteDataSource.updateOnlyImageStatus(status);

  @override
  Future<void> updateStatus(StatusEntity status) async => remoteDataSource.updateStatus(status);

}