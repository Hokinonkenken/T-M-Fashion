import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class ProductService {
  static List<Map<String, dynamic>> _products = [];

  static Future<void> loadProducts() async {
    try {
      final jsonString =
          await rootBundle.loadString('assets/product_data.json');
      final jsonResponse = json.decode(jsonString);
      _products = List<Map<String, dynamic>>.from(jsonResponse['products']);

      // Convert size lists to List<String>
      for (var product in _products) {
        if (product['size'] is List) {
          product['size'] = (product['size'] as List<dynamic>)
              .map((e) => e.toString())
              .toList();
        }
      }
    } catch (e) {
      print('Error loading products: $e');
      _products = [];
    }
  }

  static List<Map<String, dynamic>> getAllProducts() {
    return _products;
  }

  static Map<String, dynamic>? getProductById(String productId) {
    try {
      return _products.firstWhere((product) => product['id'] == productId);
    } catch (e) {
      print('Product not found: $e');
      return null;
    }
  }

  static List<Map<String, dynamic>> getProductsByCategory(String category) {
    return _products
        .where((product) => product['category'] == category)
        .toList();
  }

  static List<String> getAllCategories() {
    return _products
        .map((product) => product['category'] as String)
        .toSet()
        .toList();
  }

  static List<String> getSizesForProduct(String productId) {
    final product = getProductById(productId);
    if (product != null && product['size'] is List) {
      return List<String>.from(product['size']);
    }
    return [];
  }
}
