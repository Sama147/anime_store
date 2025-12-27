// lib/services/product_service.dart
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:anime_store/models/product.dart';

class ProductService {
  final String _baseUrl = kIsWeb
  // Use localhost for web browser builds
      ? 'http://localhost:8080'
  //10.0.2.2 for Android Emulator (Host Loopback)
      : 'http://10.0.2.2:8080';

  //Correctly defines the optional named parameter {String? category}
  Future<List<Product>> fetchProducts({String? category}) async {
    String url = '$_baseUrl/products';

    // Logic to switch between ALL products and FILTERED products
    if (category != null && category != 'All Products') {
      url = '$_baseUrl/products/filter?category=${Uri.encodeQueryComponent(category)}';
    }

    print('Fetching products from: $url');

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final List<dynamic> productsJson = jsonResponse['products'] as List<dynamic>;

        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Service Error: $e');
      throw Exception('Failed to connect to API or parse data.');
    }
  }
}