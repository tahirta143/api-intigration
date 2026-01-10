import 'package:flutter/material.dart';
import '../api_services/api_services.dart';
import '../model/users.dart';

class UserProvider extends ChangeNotifier {
  List<User> users = [];
  bool isLoading = false;
  String? errorMessage;

  // FETCH all users
  Future<void> fetchUsers() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      users = await ApiService.fetchUsers();
    } catch (e) {
      errorMessage = "Failed to fetch users: $e";
      users = [];
      print(errorMessage);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ADD user
  Future<bool> addUser(User user) async {
    try {
      isLoading = true;
      notifyListeners();

      User? newUser = await ApiService.addUser(user);

      if (newUser != null) {
        users.add(newUser);
        notifyListeners();
        return true;
      } else {
        errorMessage = "Failed to add user";
        notifyListeners();
        return false;
      }
    } catch (e) {
      errorMessage = "Error adding user: $e";
      print(errorMessage);
      notifyListeners();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // UPDATE user
  Future<bool> updateUser(User user) async {
    if (user.id == null) {
      errorMessage = "User ID is null";
      notifyListeners();
      return false;
    }

    try {
      isLoading = true;
      notifyListeners();

      User? updatedUser = await ApiService.updateUser(user);

      if (updatedUser != null) {
        int index = users.indexWhere((u) => u.id == updatedUser.id);
        if (index != -1) users[index] = updatedUser;
        notifyListeners();
        return true;
      } else {
        errorMessage = "Failed to update user";
        notifyListeners();
        return false;
      }
    } catch (e) {
      errorMessage = "Error updating user: $e";
      print(errorMessage);
      notifyListeners();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // DELETE user
  Future<bool> deleteUser(String id) async {
    if (id.isEmpty) {
      errorMessage = "User ID is null";
      notifyListeners();
      return false;
    }

    try {
      isLoading = true;
      notifyListeners();

      bool success = await ApiService.deleteUser(id);
      if (success) {
        users.removeWhere((u) => u.id == id);
        notifyListeners();
        return true;
      } else {
        errorMessage = "Failed to delete user";
        notifyListeners();
        return false;
      }
    } catch (e) {
      errorMessage = "Error deleting user: $e";
      print(errorMessage);
      notifyListeners();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
