import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/products/product.dart';

class ProductApiService {
  static const String baseUrl =
      "https://api.escuelajs.co/api/v1/products";

  // ================= GET ALL PRODUCTS =================
  static Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List list = jsonDecode(response.body);
        return list.map((e) => Product.fromJson(e)).toList();
      } else {
        print("Failed to fetch products: ${response.statusCode}");
      }
    } catch (e) {
      print("Get products error: $e");
    }
    return [];
  }

  // ================= GET SINGLE PRODUCT =================
  static Future<Product?> getProductById(int id) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/$id"));

      if (response.statusCode == 200) {
        return Product.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print("Get product error: $e");
    }
    return null;
  }

  // ================= ADD PRODUCT =================
  static Future<Product?> addProduct(Product product) async {
    try {
      final data = product.toJson();
      data.remove("id");

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Product.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print("Add product error: $e");
    }
    return null;
  }

  // ================= UPDATE PRODUCT =================
  static Future<Product?> updateProduct(Product product) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/${product.id}"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(product.toJson()),
      );

      if (response.statusCode == 200) {
        return Product.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print("Update product error: $e");
    }
    return null;
  }

  // ================= DELETE PRODUCT =================
  static Future<bool> deleteProduct(int id) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/$id"),
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print("Delete product error: $e");
      return false;
    }
  }
}
