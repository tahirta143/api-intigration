import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/employee.dart';
import '../../providers/employee_provider.dart';

class AddEmployeeScreen extends StatefulWidget {
  final Employee? employee;

  const AddEmployeeScreen({super.key, this.employee});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController imageCtrl = TextEditingController();
  final TextEditingController companyCtrl = TextEditingController();

  bool saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      nameCtrl.text = widget.employee!.name ?? "";
      imageCtrl.text = widget.employee!.image ?? "";
      companyCtrl.text = widget.employee!.company ?? "";
    }
  }

  Future<void> saveEmployee() async {
    if (nameCtrl.text.isEmpty || companyCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Name and Company are required")),
      );
      return;
    }

    setState(() => saving = true);

    final provider = context.read<EmployeeProvider>();
    bool success = false;

    if (widget.employee == null) {
      // ADD employee
      success = await provider.addEmployee(
        Employee(
          name: nameCtrl.text,
          image: imageCtrl.text,
          company: companyCtrl.text,
        ),
      );
    } else {
      // UPDATE employee
      success = await provider.updateEmployee(
        Employee(
          id: widget.employee!.id,
          name: nameCtrl.text,
          image: imageCtrl.text,
          company: companyCtrl.text,
        ),
      );
    }

    setState(() => saving = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.employee == null
              ? "Employee added successfully"
              : "Employee updated successfully"),
        ),
      );
      Navigator.pop(context, true); // return success
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.errorMessage ?? "Operation failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.employee == null ? "Add Employee" : "Edit Employee"),
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
              controller: imageCtrl,
              decoration: const InputDecoration(labelText: "Image URL"),
            ),
            TextField(
              controller: companyCtrl,
              decoration: const InputDecoration(labelText: "Company"),
            ),
            const SizedBox(height: 20),
            saving
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: saveEmployee,
              child: Text(widget.employee == null ? "Add" : "Update"),
            ),
          ],
        ),
      ),
    );
  }
}
