import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../model/product.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final title = TextEditingController();
    final description = TextEditingController();
    final price = TextEditingController();
    final section = TextEditingController();
    final images = TextEditingController();

    final provider = Provider.of<ProductProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("Add Product")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(controller: title, decoration: const InputDecoration(labelText: "Title")),
            TextField(controller: description, decoration: const InputDecoration(labelText: "Description")),
            TextField(controller: price, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Price")),
            TextField(controller: section, decoration: const InputDecoration(labelText: "Section")),
            TextField(controller: images, decoration: const InputDecoration(labelText: "Images (comma separated)")),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("Save"),
              onPressed: () async {
                final product = Product(
                  title: title.text,
                  description: description.text,
                  price: int.parse(price.text),
                  section: section.text,
                  images: images.text.split(',').map((e) => e.trim()).toList(),
                );
                await provider.addProduct(product);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
