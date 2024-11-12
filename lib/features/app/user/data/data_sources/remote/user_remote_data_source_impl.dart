import 'dart:convert';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:http/http.dart' as http;
import 'package:test_server_app/features/app/const/agora_config_const.dart';
import 'package:test_server_app/features/app/const/app_const.dart';
import 'package:test_server_app/features/app/const/exceptions.dart';
import 'package:test_server_app/features/app/user/data/data_sources/remote/user_remote_data_source.dart';
import 'package:test_server_app/features/app/user/data/data_sources/remote/user_remote_sharedprefs.dart';
import 'package:test_server_app/features/app/user/data/models/user_model.dart';
import 'package:test_server_app/features/app/user/domain/entities/contact_entity.dart';
import 'package:test_server_app/features/app/user/domain/entities/otp_entity.dart';



class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final String baseUrl;

  UserRemoteDataSourceImpl({required this.baseUrl});
  SharedPrefs sharedPrefs = SharedPrefs();
  @override
  Future<void> createUser(UserModel user) async {
    final url = Uri.parse('$baseUrl/api/users/users');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(user.toJson()),
    );
    if (response.statusCode != 201) {
      final responseData = jsonDecode(response.body);
      String userId;
      if (responseData['id'] is Map && responseData['id']['_id'] != null) {
        userId = responseData['id']['_id']; 
      } else {
        userId = responseData['id'].toString(); 
      }
      sharedPrefs.saveUid(userId);
      throw ServerException('Failed to create user');
    }
  }

  @override
  Stream<List<UserModel>> getAllUsers() async* {
    final url = Uri.parse('$baseUrl/api/users/users');
    final response = await http.get(url);
    print("========${response.body}=====");
    if (response.statusCode == 201) {
      final List<dynamic> usersJson = jsonDecode(response.body);
      final users = usersJson.map((json) => UserModel.fromJson(json)).toList();
      yield users;
    } else {
      throw ServerException('Failed to load users');
    }
  }

  @override
  Future<String> getCurrentUID() async {
    String? uid = await sharedPrefs.getUid();
    if (uid!=null) {
      return uid;
    }else{
      toast('no user id found');
    }
    return '';
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
  Stream<UserModel> getSingleUser(String uid) async* {
    print(uid);
    final url = Uri.parse('$baseUrl/api/users/users/$uid');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final userJson = jsonDecode(response.body);
      final user = UserModel.fromJson(userJson);
      yield user;
    } else {
      toast('Failed to load user');
    }
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
  Future<void> signInWithPhoneNumber(String smsPinCode) async {
    final url = Uri.parse('$baseUrl/api//users/login_with_otp');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'sms_pin_code': smsPinCode}),
    );

    if (response.statusCode != 200) {
      throw ServerException('Failed to sign in with phone number');
    }
  }

  @override
  Future<String> verifyPhoneNumber(String phoneNumber,otp) async {
    print("Sending OTP verification request: phone=$phoneNumber, otp=$otp");
    final response = await http.post(
      Uri.parse('${Config.BaseUrl}/api/users/login_with_otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phoneNumber, 'otp': otp}),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      if (result['message'] == 'Login successful') {
        print('Login successful');
      } else {
        throw Exception(result['error']);
      }
      return result['message'];
    } else {
      print("Error in login response: ${response.body}");
      throw Exception('Failed to verify OTP');
    }
  }
  @override
  Future<OTPResponse> sendOtp(String phoneNumber) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5001/api/users/request_otp'),
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
    String? uid = await sharedPrefs.getUid();
    if(uid != null){
      return true;
    }
    return false;
  }
  
  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }
  
  @override
  Future<String> resendOtp(String phoneNumber) async {
   final response = await http.post(
      Uri.parse('http://10.0.2.2:5001/api/users/resend_otp'), // Replace with your backend URL
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phoneNumber}),
    );
    final result = jsonDecode(response.body);
    print(response.body);
    if (response.statusCode == 200) {
      
      if (result['message'] == 'OTP sent successfully') {
        toast("OTP has been resent.");
        print('OTP sent successfully');
      } else {
        throw Exception('Failed to send OTP');
      }

    } else {
      throw Exception('Failed to send OTP');
    }
    return result['message'];
  }
    
  

  
  
}