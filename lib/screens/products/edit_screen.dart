import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/products/product.dart';
import '../../providers/product_provider.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product;

  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final titleCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final imageCtrl = TextEditingController();

  bool saving = false;

  @override
  void initState() {
    super.initState();

    if (widget.product != null) {
      titleCtrl.text = widget.product!.title ?? "";
      priceCtrl.text = widget.product!.price.toString();
      descCtrl.text = widget.product!.description ?? "";
      imageCtrl.text =
      widget.product!.images?.isNotEmpty == true
          ? widget.product!.images!.first
          : "";
    }
  }

  Future<void> saveProduct() async {
    if (titleCtrl.text.isEmpty || priceCtrl.text.isEmpty) return;

    setState(() => saving = true);

    final provider = context.read<ProductProvider>();
    bool success;

    final product = Product(
      id: widget.product?.id,
      title: titleCtrl.text,
      price: int.tryParse(priceCtrl.text),
      description: descCtrl.text,
      images: imageCtrl.text.isNotEmpty ? [imageCtrl.text] : [],
      category: widget.product?.category,
    );

    if (widget.product == null) {
      success = await provider.addProduct(product);
    } else {
      success = await provider.updateProduct(product);
    }

    setState(() => saving = false);

    if (success) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.errorMessage ?? "Failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        Text(widget.product == null ? "Add Product" : "Edit Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: priceCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Price"),
              ),
              TextField(
                controller: descCtrl,
                maxLines: 3,
                decoration:
                const InputDecoration(labelText: "Description"),
              ),
              TextField(
                controller: imageCtrl,
                decoration:
                const InputDecoration(labelText: "Image URL"),
              ),
              const SizedBox(height: 20),
              saving
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: saveProduct,
                child: Text(widget.product == null
                    ? "Add Product"
                    : "Update Product"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
