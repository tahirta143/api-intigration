import 'package:flutter/material.dart';
import '../api_services/api_services.dart';
import '../model/products.dart';;

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;

  bool isLoading = false;

  // Fetch all products
  Future<void> fetchProducts() async {
    isLoading = true;
    notifyListeners();

    try {
      _products = await ApiService.fetchProducts();
    } catch (e) {
      print("Error fetching products: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  // Add product
  Future<void> addProduct(Product product) async {
    Product newProduct = await ApiService.addProduct(product);
    _products.add(newProduct);
    notifyListeners();
  }

  // Update product
  Future<void> updateProduct(Product product) async {
    Product updatedProduct = await ApiService.updateProduct(product);
    int index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = updatedProduct;
      notifyListeners();
    }
  }

  // Delete product
  Future<void> deleteProduct(String id) async {
    await ApiService.deleteProduct(id);
    _products.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}
