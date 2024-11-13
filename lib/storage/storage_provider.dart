import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';


class StorageProviderRemoteDataSource {
  final String baseUrl; // The base URL of your server

  StorageProviderRemoteDataSource({required this.baseUrl});

  Future<String> uploadProfileImage({required File file, Function(bool isUploading)? onComplete}) async {
    onComplete!(true);

    final url = Uri.parse('$baseUrl/api/upload/profile');
    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('file', file.path, contentType: MediaType('image', 'png')));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final Map<String, dynamic> data = jsonDecode(responseData);
      onComplete(false);
      return data['imageUrl'];
    } else {
      onComplete(false);
      throw Exception('Failed to upload profile image');
    }
  }

  Future<String> uploadStatus({required File file, Function(bool isUploading)? onComplete}) async {
    onComplete!(true);

    final url = Uri.parse('$baseUrl/api/upload/status');
    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('file', file.path, contentType: MediaType('image', 'png')));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final Map<String, dynamic> data = jsonDecode(responseData);
      onComplete(false);
      return data['imageUrl'];
    } else {
      onComplete(false);
      throw Exception('Failed to upload status');
    }
  }

  Future<List<String>> uploadStatuses({required List<File> files, Function(bool isUploading)? onComplete}) async {
    onComplete!(true);

    List<String> imageUrls = [];
    for (var i = 0; i < files.length; i++) {
      final url = Uri.parse('$baseUrl/api/upload/status');
      final request = http.MultipartRequest('POST', url)
        ..files.add(await http.MultipartFile.fromPath('file', files[i].path, contentType: MediaType('image', 'png')));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final Map<String, dynamic> data = jsonDecode(responseData);
        imageUrls.add(data['imageUrl']);
      } else {
        onComplete(false);
        throw Exception('Failed to upload status');
      }
    }
    onComplete(false);
    return imageUrls;
  }

  Future<String> uploadMessageFile({required File file, Function(bool isUploading)? onComplete, String? uid, String? otherUid, String? type}) async {
    onComplete!(true);

    final url = Uri.parse('$baseUrl/api/upload/message/$type/$uid/$otherUid');
    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('file', file.path, contentType: MediaType('image', 'png')));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final Map<String, dynamic> data = jsonDecode(responseData);
      onComplete(false);
      return data['imageUrl'];
    } else {
      onComplete(false);
      throw Exception('Failed to upload message file');
    }
  }
}
