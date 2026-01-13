import 'package:flutter/material.dart';
import '../api_services/api_service_product.dart';
import '../model/product.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  bool isLoading = false;
  String? errorMessage;

  List<Product> get products => _products;

  /// Fetch all products from API
  Future<void> fetchProducts() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // simulate network delay for shimmer testing (optional)
      await Future.delayed(const Duration(seconds: 3));

      final products = await ApiService.getProducts();
      _products = products;
    } catch (e) {
      _products = [];
      errorMessage = "Failed to load products: $e";
      debugPrint(errorMessage);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Add a new product
  Future<void> addProduct(Product product) async {
    try {
      isLoading = true;
      notifyListeners();

      final newProduct = await ApiService.addProduct(product);
      _products.add(newProduct);
    } catch (e) {
      debugPrint("Failed to add product: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Update an existing product
  Future<void> updateProduct(Product product) async {
    try {
      isLoading = true;
      notifyListeners();

      final updated = await ApiService.updateProduct(product);
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = updated;
      }
    } catch (e) {
      debugPrint("Failed to update product: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Delete a product
  Future<void> deleteProduct(String id) async {
    try {
      isLoading = true;
      notifyListeners();

      await ApiService.deleteProduct(id);
      _products.removeWhere((p) => p.id == id);
    } catch (e) {
      debugPrint("Failed to delete product: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
