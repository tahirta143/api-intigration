import 'package:flutter/material.dart';
import '../api_services/pro_services.dart';
import '../model/pro/pro_model.dart';

class ProProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Pro> _photos = [];
  bool _isLoading = false;

  List<Pro> get photos => _photos;
  bool get isLoading => _isLoading;

  /// FETCH
  Future<void> fetchPhotos() async {
    _isLoading = true;
    notifyListeners();

    try {
      _photos = await _apiService.getPhotos();
    } catch (e) {
      print('Error fetching photos: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// ADD
  Future<void> addPhoto(Pro photo) async {
    _isLoading = true;
    notifyListeners();

    try {
      Pro newPhoto = await _apiService.addPhoto(photo);
      _photos.add(newPhoto);
    } catch (e) {
      print('Error adding photo: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// UPDATE
  Future<void> updatePhoto(String id, Pro updatedPhoto) async {
    _isLoading = true;
    notifyListeners();

    try {
      Pro? photo = await _apiService.updatePhoto(id, updatedPhoto);
      if (photo != null) {
        int index = _photos.indexWhere((p) => p.id == id);
        _photos[index] = photo;
      }
    } catch (e) {
      print('Error updating photo: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// DELETE
  Future<void> deletePhoto(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      bool deleted = await _apiService.deletePhoto(id);
      if (deleted) {
        _photos.removeWhere((p) => p.id == id);
      }
    } catch (e) {
      print('Error deleting photo: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
