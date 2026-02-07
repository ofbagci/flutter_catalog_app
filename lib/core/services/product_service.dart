import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../models/product_model.dart';

class ProductService {
  const ProductService();

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(ApiConstants.productsEndpoint));

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
      final List<dynamic> data = body['data'] as List<dynamic>;
      return data
          .map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }
}
