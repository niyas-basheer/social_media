
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:test_server_app/features/status/data/models/status_model.dart';
import 'package:test_server_app/features/status/data/remote/status_remote_data_source.dart';
import 'package:test_server_app/features/status/domain/entities/status_entity.dart';
import 'package:test_server_app/features/status/domain/entities/status_image_entity.dart';
import 'package:test_server_app/features/user/data/data_sources/remote/user_remote_sharedprefs.dart';

class StatusRemoteDataSourceImpl implements StatusRemoteDataSource {
  final String baseUrl; // The base URL of your server

  StatusRemoteDataSourceImpl({required this.baseUrl});
  SharedPrefs sharedPrefs = SharedPrefs();
  
  @override
  Future<void> createStatus(StatusEntity status) async {
    final url = Uri.parse('$baseUrl/api/status/status');
    
    
      final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(StatusModel(
        imageUrl: status.imageUrl,
        profileUrl: status.profileUrl,
        useruid: status.useruid,
        createdAt: status.createdAt,
        phoneNumber: status.phoneNumber,
        username: status.username,
        caption: status.caption,
        stories: status.stories,
      ).toMap()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create status');
    }
    
    
  }



  @override
  Future<void> deleteStatus(StatusEntity status) async {
    final url = Uri.parse('$baseUrl/api/status/status/${status.statusId}');
    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete status');
    }
  }

@override
Stream<List<StatusEntity>> getMyStatus() async* {
  try {
    String? uid = await sharedPrefs.getUid();
    if (uid == null) {
      throw Exception('User ID not found in shared preferences');
    }
    final url = Uri.parse('$baseUrl/api/status/status/$uid');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody is Map<String, dynamic> && responseBody['data'] != null) {
        final dynamic statusData = responseBody['data'];
        if (statusData is Map<String, dynamic>) {
          final createdAt = DateTime.parse(statusData['updatedAt']).toLocal();
          if (statusData['useruid'] == uid &&
              createdAt.isAfter(DateTime.now().subtract(const Duration(hours: 24)))) {
            final status = StatusModel(
              statusId: statusData['_id'] as String?,
              imageUrl: statusData['imageUrl'] as String?,
              useruid: statusData['useruid'] as String?,
              username: statusData['username'] as String?,
              profileUrl: statusData['profileUrl'] as String?,
              phoneNumber: statusData['phoneNumber'] as String?,
              caption: statusData['caption'] as String?,
              stories: (statusData['stories'] as List<dynamic>?)
                  ?.map((story) => StatusImageEntity.fromMap(story))
                  .toList(),
              createdAt: createdAt,
            );

            yield [status];
          } else {
            yield [];
          }
        } else {
          throw Exception('Unexpected data format for "data"');
        }
      } else {
        throw Exception('Invalid response: "data" key not found');
      }
    } else if (response.statusCode == 404) {
      yield [];
    } else {
      throw Exception('Failed to load statuses. Status code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error while fetching statuses: $e');
  }
}



  @override
  Future<List<StatusEntity>> getMyStatusFuture() async {
    return  getMyStatus().first;
  }

  @override
  Stream<List<StatusEntity>> getStatuses(StatusEntity status) async* {
    final url = Uri.parse('$baseUrl/api/status/statuses');
    final response = await http.get(url);
   String? uid = await sharedPrefs.getUid();
    if (response.statusCode == 200) {
      final List<dynamic> statusJson = jsonDecode(response.body);
      final statusList = statusJson.map((json) => StatusModel.fromMap(json)).toList();
     // Removes all items where the userUid matches
     statusList.removeWhere((status) => status.useruid == uid);
      yield statusList;
    } else {
      throw Exception('Failed to load statuses');
    }
  }

  @override
  Future<void> seenStatusUpdate(String statusId, int imageIndex) async {
    String? userId = await sharedPrefs.getUid();
    final url = Uri.parse('$baseUrl/api/status/status/updateViewers');
    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'statusId': statusId, "storyIndex": imageIndex, 'userId': userId}),
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
