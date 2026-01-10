import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/pro/pro_model.dart';

class ApiService {
  static const String baseUrl = 'https://picsum.photos/v2/list';

  List<Pro> _localPhotos = [];

  /// GET all photos
  Future<List<Pro>> getPhotos() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      _localPhotos = jsonData.map((e) => Pro.fromJson(e)).toList();
      return _localPhotos;
    } else {
      throw Exception('Failed to load photos');
    }
  }

  /// POST (simulate add)
  Future<Pro> addPhoto(Pro photo) async {
    photo.id = (_localPhotos.length + 1).toString();
    _localPhotos.add(photo);
    return photo;
  }

  /// PUT (simulate update)
  Future<Pro?> updatePhoto(String id, Pro updatedPhoto) async {
    int index = _localPhotos.indexWhere((p) => p.id == id);
    if (index != -1) {
      _localPhotos[index] = updatedPhoto;
      return updatedPhoto;
    }
    return null;
  }

  /// DELETE (simulate delete)
  Future<bool> deletePhoto(String id) async {
    int index = _localPhotos.indexWhere((p) => p.id == id);
    if (index != -1) {
      _localPhotos.removeAt(index);
      return true;
    }
    return false;
  }
}
