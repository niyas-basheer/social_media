import 'dart:convert';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:http/http.dart' as http;
import 'package:test_server_app/features/app/const/app_const.dart';
import 'package:test_server_app/features/app/const/exceptions.dart';
import 'package:test_server_app/features/user/data/data_sources/remote/user_remote_data_source.dart';
import 'package:test_server_app/features/user/data/data_sources/remote/user_remote_sharedprefs.dart';
import 'package:test_server_app/features/user/data/models/user_model.dart';
import 'package:test_server_app/features/user/domain/entities/contact_entity.dart';
import 'package:test_server_app/features/user/domain/entities/otp_entity.dart';



class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final String baseUrl;

  UserRemoteDataSourceImpl({required this.baseUrl});
  SharedPrefs sharedPrefs = SharedPrefs();
  String userId='';
  final sharedPrefService = SharedPrefs();
  @override
  Future<void> createUser(UserModel user) async {
    final url = Uri.parse('$baseUrl/api/users/users');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(user.toJson()),
    );
    if (response.statusCode != 201) {
      
      throw ServerException('Failed to create user');
    }
  }

  @override
   Stream<List<UserModel>> getAllUsers()async*  {
  final url = Uri.parse('$baseUrl/api/users/users');
  final response = await http.get(url);
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    final List<dynamic> usersJson = responseData['data'];
    yield (usersJson)
          .map((user) => UserModel.fromJson(user))
          .toList();
}

  @override
  Future<String> getCurrentUID() async {
    String? token = await sharedPrefs.getUid();
    if (token == null) {
      throw ServerException('Failed to get current user id');
      }
      return token;
  }

  @override
  Future<List<ContactEntity>> getDeviceNumber() async {
    List<ContactEntity> contactsList=[];

    if(await FlutterContacts.requestPermission()) {
      List<Contact> contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);

      for (var contact in contacts) {
        contactsList.add(
            ContactEntity(
                name: contact.name,
                photo: contact.photo,
                phones: contact.phones
            )
        );
      }
    }

    return contactsList;
  }

  @override
  Stream<UserModel>getSingleUser(String uid)async*  {
    final url = Uri.parse('$baseUrl/api/users/users/$uid');
    final response = await http.get(url);
      final Map<String, dynamic>responseData = jsonDecode(response.body);
      final usersJson = UserModel.fromJson(responseData['data']);
      yield usersJson;
  }

  @override
  Future<void> updateUser(UserModel user) async {
    final url = Uri.parse('$baseUrl/api/users/users/${user.uid}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode != 200) {
      throw ServerException('Failed to update user');
    }
  }

  Future<void> deleteUser(String uid) async {
    final url = Uri.parse('$baseUrl/api/users/users/$uid');
    final response = await http.delete(url);

    if (response.statusCode != 204) {
      throw ServerException('Failed to delete user');
    }
  }



  @override
Future<String> verifyPhoneNumber(String phoneNumber, String otp) async {

  final response = await http.post(
    Uri.parse('$baseUrl/api/users/login_with_otp'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'phone': phoneNumber, 'otp': otp}),
  );


  if (response.statusCode == 200) {
    final result = jsonDecode(response.body);
    
    // Handle unexpected response structure
    if (result == null || !result.containsKey('message')) {
      throw Exception('Unexpected response structure');
    }

    if (result['message'] == 'Login successful') {
      final Map<String, dynamic> parsed = jsonDecode(response.body);
     final userdata = UserModel.fromJson(parsed['user']);
      
     userId = userdata.uid ?? '';
       sharedPrefs.saveUid(userId);
       sharedPrefService.saveSignInStatus(true); 

      return result['message'];
    } else {
      // Handle server error message
      throw Exception(result['error'] ?? 'Unknown error');
    }
  } else {
    // Handle HTTP errors
    throw Exception('Failed to verify OTP. Status code: ${response.statusCode}');
  }
}
  @override
  Future<OTPResponse> sendOtp(String phoneNumber) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/users/request_otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phoneNumber}),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return OTPResponse(result['message']);
    } else {
      throw Exception('Failed to send OTP');
    }
  }
  @override
  Future<bool> isSignIn() async{
    
    final sharedPrefService = SharedPrefs(); 
    bool isSignedIn = await sharedPrefService.getSignInStatus();
    return isSignedIn;
    
  }
  
  @override
  Future<void> signOut() {
    throw UnimplementedError();
  }
  
  @override
  Future<String> resendOtp(String phoneNumber) async {
   final response = await http.post(
      Uri.parse('$baseUrl/api/users/resend_otp'), 
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phoneNumber}),
    );
    final result = jsonDecode(response.body);
    if (response.statusCode == 200) {
      
      if (result['message'] == 'OTP sent successfully') {
        toast("OTP has been resent.");
      } else {
        throw Exception('Failed to send OTP');
      }

    } else {
      throw Exception('Failed to send OTP');
    }
    return result['message'];
  }
    
  

  
  
}