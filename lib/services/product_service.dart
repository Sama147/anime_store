// lib/services/product_service.dart
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:anime_store/models/product.dart';

class ProductService {
  final String _baseUrl = kIsWeb
      ? 'http://localhost:8080'
      : 'http://10.0.2.2:8080';

  Future<List<Product>> fetchProducts({String? category}) async {
    String url = '$_baseUrl/products';

    if (category != null && category != 'All Products') {
      url = '$_baseUrl/products/filter?category=${Uri.encodeQueryComponent(category)}';
    }

    print('Fetching products from: $url');

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final List<dynamic> productsJson = jsonResponse['products'] as List<dynamic>;

        // Correctly calls the Product.fromJson which now expects quantity and id
        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Server returned status: ${response.statusCode}');
      }
    } catch (e) {
      print('Service Error: $e');
      throw Exception('Failed to connect to API: $e');
    }
  }
}