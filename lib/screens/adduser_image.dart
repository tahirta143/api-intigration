import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/pro/pro_model.dart';
import '../providers/pro.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController authorController = TextEditingController();
  final TextEditingController widthController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController urlController = TextEditingController();

  @override
  void dispose() {
    authorController.dispose();
    widthController.dispose();
    heightController.dispose();
    urlController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      final newPhoto = Pro(
        author: authorController.text,
        width: int.parse(widthController.text),
        height: int.parse(heightController.text),
        url: urlController.text,
        downloadUrl: 'https://picsum.photos/200',
      );

      Provider.of<ProProvider>(context, listen: false)
          .addPhoto(newPhoto);

      Navigator.pop(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: authorController,
                decoration: const InputDecoration(labelText: 'Author Name'),
                validator: (value) =>
                value!.isEmpty ? 'Enter author name' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: widthController,
                decoration: const InputDecoration(labelText: 'Width'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value!.isEmpty ? 'Enter width' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: heightController,
                decoration: const InputDecoration(labelText: 'Height'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value!.isEmpty ? 'Enter height' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: urlController,
                decoration: const InputDecoration(labelText: 'URL'),
                validator: (value) =>
                value!.isEmpty ? 'Enter url' : null,
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _submit,
                child: const Text('Add User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
