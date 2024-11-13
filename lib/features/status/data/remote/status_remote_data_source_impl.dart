
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:test_server_app/features/status/data/models/status_model.dart';
import 'package:test_server_app/features/status/data/remote/status_remote_data_source.dart';
import 'package:test_server_app/features/status/domain/entities/status_entity.dart';
import 'package:test_server_app/features/status/domain/entities/status_image_entity.dart';

class StatusRemoteDataSourceImpl implements StatusRemoteDataSource {
  final String baseUrl; // The base URL of your server

  StatusRemoteDataSourceImpl({required this.baseUrl});

  @override
  Future<void> createStatus(StatusEntity status) async {
    final url = Uri.parse('$baseUrl/api/status/create');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(StatusModel(
        imageUrl: status.imageUrl,
        profileUrl: status.profileUrl,
        uid: status.uid,
        createdAt: status.createdAt,
        phoneNumber: status.phoneNumber,
        username: status.username,
        statusId: '', // Leave empty, server can generate
        caption: status.caption,
        stories: status.stories,
      ).toDocument()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create status');
    }
  }

  @override
  Future<void> deleteStatus(StatusEntity status) async {
    final url = Uri.parse('$baseUrl/api/status/delete/${status.statusId}');
    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete status');
    }
  }

  @override
  Stream<List<StatusEntity>> getMyStatus(String uid) async* {
    final url = Uri.parse('$baseUrl/api/status/user/$uid');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> statusJson = jsonDecode(response.body);
      final statusList = statusJson.map((json) => StatusModel.fromSnapshot(json)).toList();
      yield statusList;
    } else {
      throw Exception('Failed to load statuses');
    }
  }

  @override
  Future<List<StatusEntity>> getMyStatusFuture(String uid) async {
    final url = Uri.parse('$baseUrl/api/status/user/$uid');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> statusJson = jsonDecode(response.body);
      return statusJson.map((json) => StatusModel.fromSnapshot(json)).toList();
    } else {
      throw Exception('Failed to load statuses');
    }
  }

  @override
  Stream<List<StatusEntity>> getStatuses(StatusEntity status) async* {
    final url = Uri.parse('$baseUrl/api/status/recent');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> statusJson = jsonDecode(response.body);
      final statusList = statusJson.map((json) => StatusModel.fromSnapshot(json)).toList();
      yield statusList;
    } else {
      throw Exception('Failed to load statuses');
    }
  }

  @override
  Future<void> seenStatusUpdate(String statusId, int imageIndex, String userId) async {
    final url = Uri.parse('$baseUrl/api/status/seen');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'statusId': statusId, 'imageIndex': imageIndex, 'userId': userId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update status viewers');
    }
  }

  @override
  Future<void> updateOnlyImageStatus(StatusEntity status) async {
    final url = Uri.parse('$baseUrl/api/status/update/${status.statusId}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'stories': status.stories!.map((e) => StatusImageEntity.toJsonStatic(e)).toList()}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update status');
    }
  }

  @override
  Future<void> updateStatus(StatusEntity status) async {
    final url = Uri.parse('$baseUrl/api/status/update/${status.statusId}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'imageUrl': status.imageUrl,
        'stories': status.stories,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update status');
    }
  }
}