import 'package:flutter/material.dart';
import '../../api_services/api_services_employees.dart';
import '../../model/employee.dart';

class EmployeeProvider extends ChangeNotifier {
  List<Employee> employees = [];
  bool isLoading = false;
  String? errorMessage;

  // FETCH all employees
  Future<void> fetchEmployees() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      employees = await EmployeeApiService.getEmployees();
    } catch (e) {
      errorMessage = "Failed to fetch employees: $e";
      employees = [];
      print(errorMessage);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ADD employee
  Future<bool> addEmployee(Employee emp) async {
    isLoading = true;
    notifyListeners();

    try {
      final Employee? newEmp = await EmployeeApiService.addEmployee(emp);

      if (newEmp != null) {
        employees.add(newEmp);
        notifyListeners();
        return true;
      } else {
        errorMessage = "Failed to add employee";
        notifyListeners();
        return false;
      }
    } catch (e) {
      errorMessage = "Error adding employee: $e";
      print(errorMessage);
      notifyListeners();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // UPDATE employee
  Future<bool> updateEmployee(Employee emp) async {
    if (emp.id == null) {
      errorMessage = "Employee ID is null";
      notifyListeners();
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      bool success = await EmployeeApiService.updateEmployee(emp);

      if (success) {
        final index = employees.indexWhere((e) => e.id == emp.id);
        if (index != -1) employees[index] = emp;
        notifyListeners();
        return true;
      } else {
        errorMessage = "Failed to update employee";
        notifyListeners();
        return false;
      }
    } catch (e) {
      errorMessage = "Error updating employee: $e";
      print(errorMessage);
      notifyListeners();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // DELETE employee
  Future<bool> deleteEmployee(String id) async {
    if (id.isEmpty) {
      errorMessage = "Employee ID is null";
      notifyListeners();
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      bool success = await EmployeeApiService.deleteEmployee(id);

      if (success) {
        employees.removeWhere((e) => e.id.toString() == id.toString());
        notifyListeners();
        return true;
      } else {
        errorMessage = "Failed to delete employee";
        notifyListeners();
        return false;
      }
    } catch (e) {
      errorMessage = "Error deleting employee: $e";
      print(errorMessage);
      notifyListeners();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
