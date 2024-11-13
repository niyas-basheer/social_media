// credential_cubit_test.dart

import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:test_server_app/features/app/const/agora_config_const.dart';
import 'package:test_server_app/features/app/const/exceptions.dart';
import 'package:test_server_app/features/user/data/data_sources/remote/user_remote_data_source.dart';
import 'package:test_server_app/features/user/data/data_sources/remote/user_remote_data_source_impl.dart';
import 'package:test_server_app/features/user/data/data_sources/remote/user_remote_sharedprefs.dart';
import 'package:test_server_app/features/user/data/models/user_model.dart';
import 'package:test_server_app/features/user/presentation/cubit/credential/credential_cubit.dart'; // Adjust based on actual file path
 

// Mock classes
class MockClient extends Mock implements http.Client {}
class MockSharedPrefs extends Mock implements SharedPrefs {}

void main() {
  late MockClient mockClient;
  late MockSharedPrefs mockSharedPrefs;
  late UserRemoteDataSource userRemoteDataSource; 

  setUp(() {
    mockClient = MockClient();
    mockSharedPrefs = MockSharedPrefs();
    userRemoteDataSource = UserRemoteDataSourceImpl(baseUrl: Config.BaseUrl);
  });

  test('should save UID and throw ServerException when response status is not 201', () async {
    const user = UserModel(phoneNumber: '7025332088',isOnline: true,profileUrl:"//https://firebasestorage.googleapis.com/v0/b/socialmedia-441409.fire//basestorage.app/o/User%2FImages%2FProfile%2F1000000018.jpg?alt=media&token=d536e487-e9aa-4e69-9780-3b4d8e833ceb" ,status: 'active,');
    final url = Uri.parse('${Config.BaseUrl}/api/users/users',);

    when(mockClient.post(url,
        headers: anyNamed('headers'), body: anyNamed('body'))).thenAnswer(
        (_) async => http.Response('{"id": {"_id": "12345"}}', 400));

    expect(() async => await userRemoteDataSource.createUser(user),
        throwsA(isA<ServerException>()));

    verify(mockSharedPrefs.saveUid("12345")).called(1);
  });

  test('should not call saveUid and complete normally when response status is 201', () async {
    const user = UserModel(/* initialize your user here */);
    final url = Uri.parse('${Config.BaseUrl}/api/users/users');

    when(mockClient.post(url,
        headers: anyNamed('headers'), body: anyNamed('body'))).thenAnswer(
        (_) async => http.Response('', 201));

    await userRemoteDataSource.createUser(user);

    verifyNever(mockSharedPrefs.saveUid(''));
  });
}
