
import 'package:test_server_app/features/app/user/data/data_sources/remote/user_remote_data_source.dart';
import 'package:test_server_app/features/app/user/data/models/user_model.dart';
import 'package:test_server_app/features/app/user/domain/entities/contact_entity.dart';
import 'package:test_server_app/features/app/user/domain/entities/user_entity.dart';
import 'package:test_server_app/features/app/user/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> createUser(UserModel user) async => remoteDataSource.createUser(user);

  @override
  Stream<List<UserEntity>> getAllUsers() => remoteDataSource.getAllUsers();

  @override
  Future<String> getCurrentUID() async => remoteDataSource.getCurrentUID();

  @override
  Future<List<ContactEntity>> getDeviceNumber() async => remoteDataSource.getDeviceNumber();

  @override
  Stream<UserModel> getSingleUser(String uid) => remoteDataSource.getSingleUser(uid);
  @override
  Future<bool> isSignIn() async => remoteDataSource.isSignIn();

  @override
  Future<void> signInWithPhoneNumber(String smsPinCode) async => remoteDataSource.signInWithPhoneNumber(smsPinCode);

  @override
  Future<void> signOut() async => remoteDataSource.signOut();

  @override
  Future<void> updateUser(UserModel user) async => remoteDataSource.updateUser(user);

  @override
  Future<void> verifyPhoneNumber(String phoneNumber) async => remoteDataSource.verifyPhoneNumber(phoneNumber);

}