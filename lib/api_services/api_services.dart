import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/users.dart';

class ApiService {
  static const String baseUrl =
      "https://api-generator.retool.com/egYrm9/data";

  // GET USERS
  static Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body);
      return list.map((e) => User.fromJson(e)).toList();
    }

    return [];
  }

  // ADD USER
  static Future<User?> addUser(User user) async {
    final data = user.toJson();
    data.remove("id");

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    }

    return null;
  }

  // UPDATE USER
  static Future<User?> updateUser(User user) async {
    final url = "$baseUrl/${user.id}";

    final response = await http.put(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    }

    return null;
  }

  // DELETE USER
  static Future<bool> deleteUser(String id) async {
    final url = "$baseUrl/$id";

    final response = await http.delete(Uri.parse(url));

    return response.statusCode == 200 || response.statusCode == 204;
  }
}
