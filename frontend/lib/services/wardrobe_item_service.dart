import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/api_constant.dart';
import 'auth_service.dart';

class WardrobeItemService {
  Future<Map<String, String>> getHeaders() async {
  final authService = AuthService();
  final token = await authService.getToken();

  if (token == null || token.isEmpty) {
    throw Exception('Token tidak ditemukan. Silakan login kembali.');
  }

  return {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };
}

  // GET: Mengambil semua item
  Future<List<dynamic>> getItems() async {
    final response = await http.get(
      Uri.parse(
        '${ApiConstant.baseUrlLaravel}${ApiConstant.wardrobeItems}',
      ),
      headers: await getHeaders(),
    );

    final result = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return result['data'];
    }

    throw Exception(result['message'] ?? 'Gagal mengambil item');
  }

  // POST: Menambahkan item
  Future<void> addItem({
    required int outfitId,
    required String title,
    double? price,
    String? color,
    String? notes,
    String? imageUrl,
  }) async {
    final response = await http.post(
      Uri.parse(
        '${ApiConstant.baseUrlLaravel}${ApiConstant.wardrobeItems}',
      ),
      headers: await getHeaders(),
      body: jsonEncode({
        'outfit_id': outfitId,
        'title': title,
        'price': price,
        'color': color,
        'notes': notes,
        'image_url': imageUrl,
      }),
    );

    if (response.statusCode != 201) {
      final result = jsonDecode(response.body);
      throw Exception(result['message'] ?? 'Gagal menambahkan item');
    }
  }

  // PUT: Mengedit item
  Future<void> updateItem(
    int id, {
    required int outfitId,
    required String title,
    double? price,
    String? color,
    String? notes,
    String? imageUrl,
  }) async {
    final response = await http.put(
      Uri.parse(
        '${ApiConstant.baseUrlLaravel}${ApiConstant.wardrobeItems}/$id',
      ),
      headers: await getHeaders(),
      body: jsonEncode({
        'outfit_id': outfitId,
        'title': title,
        'price': price,
        'color': color,
        'notes': notes,
        'image_url': imageUrl,
      }),
    );

    if (response.statusCode != 200) {
      final result = jsonDecode(response.body);
      throw Exception(result['message'] ?? 'Gagal memperbarui item');
    }
  }

  // DELETE: Menghapus item
  Future<void> deleteItem(int id) async {
    final response = await http.delete(
      Uri.parse(
        '${ApiConstant.baseUrlLaravel}${ApiConstant.wardrobeItems}/$id',
      ),
      headers: await getHeaders(),
    );

    if (response.statusCode != 200) {
      final result = jsonDecode(response.body);
      throw Exception(result['message'] ?? 'Gagal menghapus item');
    }
  }
}