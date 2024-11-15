

import 'package:test_server_app/features/user/data/data_sources/remote/user_remote_data_source.dart';
import 'package:test_server_app/features/user/data/models/user_model.dart';
import 'package:test_server_app/features/user/domain/entities/contact_entity.dart';
import 'package:test_server_app/features/user/domain/entities/otp_entity.dart';
import 'package:test_server_app/features/user/domain/entities/user_entity.dart';
import 'package:test_server_app/features/user/domain/repository/user_repository.dart';

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
  Stream<UserModel> getSingleUser() => remoteDataSource.getSingleUser();
  @override
  Future<bool> isSignIn() async => remoteDataSource.isSignIn();
  @override
  Future<void> signOut() async => remoteDataSource.signOut();

  @override
  Future<void> updateUser(UserModel user) async => remoteDataSource.updateUser(user);

  @override
  Future<String> verifyPhoneNumber(String phoneNumber,otp) async => remoteDataSource.verifyPhoneNumber(phoneNumber,otp);

  @override
  Future<OTPResponse> sendOtp(String phoneNumber) async => remoteDataSource.sendOtp(phoneNumber);
  
  @override
  Future<String> resendOtp(String phoneNumber) async => remoteDataSource.resendOtp(phoneNumber);


}