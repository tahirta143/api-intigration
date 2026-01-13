import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/product.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:5000/api/products";

  static Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Product.fromJson(e)).toList();
    }
    throw Exception("Failed to load products");
  }

  static Future<Product> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(product.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Product.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to add product");
  }

  static Future<Product> updateProduct(Product product) async {
    final response = await http.put(
      Uri.parse("$baseUrl/${product.id}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(product.toJson()),
    );
    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to update product");
  }

  static Future<void> deleteProduct(String id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));
    if (response.statusCode != 200) {
      throw Exception("Failed to delete product");
    }
  }
}
