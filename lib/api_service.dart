import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = "http://localhost:5001/api";

  Future<http.Response> getData(String endpoint) async {
    final response = await http.get(Uri.parse('$_baseUrl/$endpoint'));
    return response;
  }

  Future<http.Response> postData(String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    return response;
  }
}
