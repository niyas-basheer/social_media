import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test_server_app/features/app/const/exceptions.dart';
import 'package:test_server_app/features/app/user/data/data_sources/remote/user_remote_data_source.dart';
import 'package:test_server_app/features/app/user/data/models/user_model.dart';
import 'package:test_server_app/features/app/user/domain/entities/contact_entity.dart';



class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final String baseUrl;

  UserRemoteDataSourceImpl({required this.baseUrl});

  @override
  Future<void> createUser(UserModel user) async {
    final url = Uri.parse('$baseUrl/api/users');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode != 201) {
      throw ServerException();
    }
  }

  @override
  Stream<List<UserModel>> getAllUsers() async* {
    final url = Uri.parse('$baseUrl/api/users');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> usersJson = jsonDecode(response.body);
      final users = usersJson.map((json) => UserModel.fromJson(json)).toList();
      yield users;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<String> getCurrentUID() async {
    // Implement your logic to get current UID, possibly using authentication tokens.
    throw UnimplementedError();
  }

  @override
  Future<List<ContactEntity>> getDeviceNumber() async {
    // Your existing logic for fetching device contacts
    throw UnimplementedError();
  }

  @override
  Stream<UserModel> getSingleUser(String uid) async* {
    final url = Uri.parse('$baseUrl/api/users/$uid');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final userJson = jsonDecode(response.body);
      final user = UserModel.fromJson(userJson);
      yield user;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> updateUser(UserModel user) async {
    final url = Uri.parse('$baseUrl/api/users/${user.uid}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode != 200) {
      throw ServerException();
    }
  }

  Future<void> deleteUser(String uid) async {
    final url = Uri.parse('$baseUrl/api/users/$uid');
    final response = await http.delete(url);

    if (response.statusCode != 204) {
      throw ServerException();
    }
  }

  @override
  Future<void> signInWithPhoneNumber(String smsPinCode) async {
    // You will need to implement the login logic as per your backend API
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() async {
    // Implement your sign-out logic if needed
    throw UnimplementedError();
  }

  @override
  Future<void> verifyPhoneNumber(String phoneNumber) async {
    // Implement the phone number verification logic as per your backend API
    throw UnimplementedError();
  }
  
  @override
  Future<bool> isSignIn() {
    // TODO: implement isSignIn
    throw UnimplementedError();
  }
}
