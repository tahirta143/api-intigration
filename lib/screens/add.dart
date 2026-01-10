import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/users.dart';
import '../../providers/user_provider.dart';

class AddUserScreen extends StatefulWidget {
  final User? user;

  const AddUserScreen({super.key, this.user});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  bool saving = false;

  @override
  void initState() {
    super.initState();

    if (widget.user != null) {
      nameCtrl.text = widget.user!.name ?? "";
      emailCtrl.text = widget.user!.email ?? "";
    }
  }

  Future<void> save() async {
    if (nameCtrl.text.isEmpty || emailCtrl.text.isEmpty) return;

    setState(() => saving = true);

    final provider = context.read<UserProvider>();

    final user = User(
      id: widget.user?.id,
      name: nameCtrl.text,
      email: emailCtrl.text,
    );

    if (widget.user == null) {
      // ADD
      await provider.addUser(user);
    } else {
      // UPDATE
      await provider.updateUser(user);
    }

    setState(() => saving = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user == null ? "Add User" : "Edit User"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 20),
            saving
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: save,
              child: Text(
                widget.user == null ? "Add User" : "Update User",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
