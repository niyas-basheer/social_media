


import 'package:test_server_app/features/user/data/models/user_model.dart';
import 'package:test_server_app/features/user/domain/entities/contact_entity.dart';
import 'package:test_server_app/features/user/domain/entities/otp_entity.dart';

abstract class UserRemoteDataSource {

  Future<String> verifyPhoneNumber(String phoneNumber,String otp);
  Future<String> resendOtp(String phoneNumber);
  Future<bool> isSignIn();
  Future<void> signOut();
  Future<String> getCurrentUID();
  Future<void> createUser(UserModel user);
  Future<void> updateUser(UserModel user);
  Stream<List<UserModel>> getAllUsers();
  Stream<UserModel> getSingleUser(String uid);
Future<OTPResponse> sendOtp(String phoneNumber);
  Future<List<ContactEntity>> getDeviceNumber();
}