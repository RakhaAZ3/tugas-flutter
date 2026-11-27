
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constant.dart';

class ApiService {
  Future<Map<String, String>> getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>> getUser() async {
    final response = await http.get(
      Uri.parse('${ApiConstant.baseUrlLaravel}${ApiConstant.user}'),
      headers: await getHeaders(),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(data['user'] ?? data);
    }

    throw Exception(data['message'] ?? 'Gagal mengambil data user');
  }

  Future<void> logout() async {
    final response = await http.post(
      Uri.parse('${ApiConstant.baseUrlLaravel}${ApiConstant.logout}'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
    } else {
      throw Exception('Logout gagal: ${response.body}');
    }
  }
}
