import 'package:flutter/material.dart';
import '../api_services/api_services_products.dart';
import '../model/products/product.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> products = [];
  bool isLoading = false;
  String? errorMessage;

  // ================= FETCH PRODUCTS =================
  Future<void> fetchProducts() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      products = await ProductApiService.getProducts();
    } catch (e) {
      errorMessage = "Failed to fetch products: $e";
      products = [];
      debugPrint(errorMessage);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ================= ADD PRODUCT =================
  Future<bool> addProduct(Product product) async {
    isLoading = true;
    notifyListeners();

    try {
      final newProduct = await ProductApiService.addProduct(product);
      if (newProduct != null) {
        products.insert(0, newProduct);
        return true;
      } else {
        errorMessage = "Failed to add product";
        return false;
      }
    } catch (e) {
      errorMessage = "Error adding product: $e";
      debugPrint(errorMessage);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ================= UPDATE PRODUCT =================
  Future<bool> updateProduct(Product product) async {
    if (product.id == null) {
      errorMessage = "Product ID is null";
      notifyListeners();
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      final updatedProduct =
      await ProductApiService.updateProduct(product);

      if (updatedProduct != null) {
        final index =
        products.indexWhere((p) => p.id == updatedProduct.id);
        if (index != -1) products[index] = updatedProduct;
        return true;
      } else {
        errorMessage = "Failed to update product";
        return false;
      }
    } catch (e) {
      errorMessage = "Error updating product: $e";
      debugPrint(errorMessage);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ================= DELETE PRODUCT =================
  Future<bool> deleteProduct(int id) async {
    isLoading = true;
    notifyListeners();

    try {
      final success = await ProductApiService.deleteProduct(id);
      if (success) {
        products.removeWhere((p) => p.id == id);
        return true;
      } else {
        errorMessage = "Failed to delete product";
        return false;
      }
    } catch (e) {
      errorMessage = "Error deleting product: $e";
      debugPrint(errorMessage);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
