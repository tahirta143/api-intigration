import 'dart:convert';
import 'package:api_practice/model/employee.dart';
import 'package:http/http.dart' as http;

class EmployeeApiService{
  static const String baseUrl = "https://api-generator.retool.com/U4NpuG/data";
  // get employees
  static Future<List<Employee>> getEmployees() async{
    try{
      final response = await http.get(Uri.parse(baseUrl));
      if(response.statusCode==200){
        List list=jsonDecode(response.body);
        return list.map((e) => Employee.fromJson(e)).toList();
      }

    }
    catch(e){
      print("Get employyes error: $e");
    }
    return [];
  }


  //ADD employees

  // ADD employee
  static Future<Employee?> addEmployee(Employee employee) async {
    try {
      final data = employee.toJson();
      data.remove("id");

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Employee.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print("ADD employee error: $e");
    }

    return null;
  }
 // Update employee
  static Future<bool> updateEmployee(Employee employee) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/${employee.id}"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(employee.toJson()),
      );

      return response.statusCode == 200;
    } catch (e) {
      print("UPDATE employee error: $e");
      return false;
    }
  }

  // DELETE employee
  static Future<bool> deleteEmployee(String id) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/$id"),
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print("DELETE employee error: $e");
      return false;
    }
  }

}