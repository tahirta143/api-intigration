import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../providers/product_provider.dart';
import 'add_product.dart';
import 'edit_product.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  // Realistic shimmer tile (image + text)
  Widget productShimmerTile() {
    return Card(
      color: Colors.red.shade50,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: ListTile(
        leading: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(width: 60, height: 60, color: Colors.white),
        ),
        title: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(height: 12, width: double.infinity, color: Colors.white, margin: const EdgeInsets.symmetric(vertical: 4)),
        ),
        subtitle: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(height: 10, width: double.infinity, color: Colors.white, margin: const EdgeInsets.symmetric(vertical: 2)),
              Container(height: 10, width: 80, color: Colors.white, margin: const EdgeInsets.symmetric(vertical: 2)),
              Container(height: 10, width: 40, color: Colors.white, margin: const EdgeInsets.symmetric(vertical: 2)),
            ],
          ),
        ),
      ),
    );
  }

  // Shimmer list
  Widget productShimmerList() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) => productShimmerTile(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        title: const Text("Products"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddProductScreen()),
              );
            },
          ),
        ],
      ),
      body: provider.isLoading
          ? productShimmerList()
          : provider.errorMessage != null
          ? Center(child: Text(provider.errorMessage!))
          : ListView.builder(
        itemCount: provider.products.length,
        itemBuilder: (context, index) {
          final p = provider.products[index];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Card(
              color: Colors.red.shade50,
              child: ListTile(
                leading: Image.network(
                  p.images.first,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
                title: Text(p.title),
                subtitle: Text(
                  "${p.description}\nSection: ${p.section}\nPrice: ₹${p.price}",
                ),
                isThreeLine: true,
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await provider.deleteProduct(p.id!);
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditProductScreen(product: p),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
