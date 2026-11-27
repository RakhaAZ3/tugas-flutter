
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constant.dart';
import '../models/outfit_model.dart';
import 'api_service.dart';

class OutfitService {
  final ApiService apiService = ApiService();

  Future<List<Outfit>> getOutfits() async {
    final response = await http.get(
      Uri.parse('${ApiConstant.baseUrlLaravel}${ApiConstant.outfits}'),
      headers: await apiService.getHeaders(),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data.map((item) => Outfit.fromJson(item)).toList();
    }

    throw Exception('Gagal mengambil kategori');
  }

  Future<void> addOutfit(String name) async {
    final response = await http.post(
      Uri.parse('${ApiConstant.baseUrlLaravel}${ApiConstant.outfits}'),
      headers: await apiService.getHeaders(),
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode != 201) {
      throw Exception('Gagal menambahkan kategori: ${response.body}');
    }
  }

  Future<void> updateOutfit(int id, String name) async {
    final response = await http.put(
      Uri.parse('${ApiConstant.baseUrlLaravel}${ApiConstant.outfits}/$id'),
      headers: await apiService.getHeaders(),
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal memperbarui kategori: ${response.body}');
    }
  }

  Future<void> deleteOutfit(int id) async {
    final response = await http.delete(
      Uri.parse('${ApiConstant.baseUrlLaravel}${ApiConstant.outfits}/$id'),
      headers: await apiService.getHeaders(),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus kategori: ${response.body}');
    }
  }
}
