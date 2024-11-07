
import 'package:test_server_app/features/app/user/data/models/user_model.dart';
import 'package:test_server_app/features/app/user/domain/entities/contact_entity.dart';
import 'package:test_server_app/features/app/user/domain/entities/user_entity.dart';

abstract class UserRepository {

  Future<void> verifyPhoneNumber(String phoneNumber);
  Future<void> signInWithPhoneNumber(String smsPinCode);

  Future<bool> isSignIn();
  Future<void> signOut();
  Future<String> getCurrentUID();
  Future<void> createUser(UserModel user);
  Future<void> updateUser(UserModel user);
  Stream<List<UserEntity>> getAllUsers();
  Stream<UserModel> getSingleUser(String uid);

  Future<List<ContactEntity>> getDeviceNumber();
}