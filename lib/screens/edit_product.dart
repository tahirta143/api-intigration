import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../model/product.dart';

class EditProductScreen extends StatelessWidget {
  final Product product;
  const EditProductScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final title = TextEditingController(text: product.title);
    final description = TextEditingController(text: product.description);
    final price = TextEditingController(text: product.price.toString());
    final section = TextEditingController(text: product.section);
    final images = TextEditingController(text: product.images.join(','));

    final provider = Provider.of<ProductProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Product")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(controller: title),
            TextField(controller: description),
            TextField(controller: price, keyboardType: TextInputType.number),
            TextField(controller: section),
            TextField(controller: images),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("Update"),
              onPressed: () async {
                final updated = Product(
                  id: product.id,
                  title: title.text,
                  description: description.text,
                  price: int.parse(price.text),
                  section: section.text,
                  images: images.text.split(',').map((e) => e.trim()).toList(),
                );
                await provider.updateProduct(updated);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
