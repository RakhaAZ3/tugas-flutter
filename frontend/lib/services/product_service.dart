
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constant.dart';
import '../models/product_model.dart';

class ProductService {
  Future<List<Product>> getProducts() async {
    final response = await http.get(
      Uri.parse(ApiConstant.publicApiUrl),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data
          .map((item) => Product.fromJson(item))
          .toList();
    } else {
      throw Exception('Gagal mengambil data produk');
    }
  }
}
