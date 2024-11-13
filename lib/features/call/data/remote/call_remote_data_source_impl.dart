import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test_server_app/features/call/data/models/call_model.dart';
import 'package:test_server_app/features/call/data/remote/call_remote_data_source.dart';
import 'package:test_server_app/features/call/domain/entities/call_entity.dart';

class CallRemoteDataSourceImpl implements CallRemoteDataSource {
  final String baseUrl; // The base URL of your server
  
  CallRemoteDataSourceImpl({required this.baseUrl});

  @override
  Future<void> endCall(CallEntity call) async {
    final url = Uri.parse('$baseUrl/api/call/end');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'callerId': call.callerId,
        'receiverId': call.receiverId,
      }),
    );

    if (response.statusCode != 200) {
      print("something went wrong");
    }
  }

  @override
  Future<String> getCallChannelId(String uid) async {
    final url = Uri.parse('$baseUrl/api/call/channel/$uid');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['callId'];
    } else {
      throw Exception('Failed to load call channel ID');
    }
  }

  @override
  Stream<List<CallEntity>> getMyCallHistory(String uid) async* {
    final url = Uri.parse('$baseUrl/api/calls/getMyCallHistory/$uid');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> callsJson = jsonDecode(response.body);
      final calls = callsJson.map((json) => CallModel.fromJson(json)).toList();
      yield calls;
    } else {
      throw Exception('Failed to load call history');
    }
  }

  @override
  Stream<List<CallEntity>> getUserCalling(String uid) async* {
    final url = Uri.parse('$baseUrl/api/call/ongoing/$uid');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> callsJson = jsonDecode(response.body);
      final calls = callsJson.map((json) => CallModel.fromJson(json)).toList();
      yield calls;
    } else {
      throw Exception('Failed to load ongoing calls');
    }
  }

  @override
  Future<void> makeCall(CallEntity call) async {
    final url = Uri.parse('$baseUrl/api/call/start');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(CallModel(
        callerId: call.callerId,
        callerName: call.callerName,
        callerProfileUrl: call.callerProfileUrl,
        callId: call.callId,
        isCallDialed: call.isCallDialed,
        isMissed: call.isMissed,
        receiverId: call.receiverId,
        receiverName: call.receiverName,
        receiverProfileUrl: call.receiverProfileUrl,
        createdAt: DateTime.now(),
      ).toJson()),
    );

    if (response.statusCode != 200) {
      print("something went wrong");
    }
  }

  @override
  Future<void> saveCallHistory(CallEntity call) async {
    final url = Uri.parse('$baseUrl/api/call/history');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(CallModel(
        callerId: call.callerId,
        callerName: call.callerName,
        callerProfileUrl: call.callerProfileUrl,
        callId: call.callId,
        isCallDialed: call.isCallDialed,
        isMissed: call.isMissed,
        receiverId: call.receiverId,
        receiverName: call.receiverName,
        receiverProfileUrl: call.receiverProfileUrl,
        createdAt: DateTime.now(),
      ).toJson()),
    );

    if (response.statusCode != 200) {
      print("something went wrong");
    }
  }

  @override
  Future<void> updateCallHistoryStatus(CallEntity call) async {
    final url = Uri.parse('$baseUrl/api/call/history/status');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'callId': call.callId,
        'isCallDialed': call.isCallDialed,
        'isMissed': call.isMissed,
      }),
    );

    if (response.statusCode != 200) {
      print("something went wrong");
    }
  }
}
