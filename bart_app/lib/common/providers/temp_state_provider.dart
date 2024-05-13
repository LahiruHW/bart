
import 'package:flutter/material.dart';

/// used to store temporary state that is not related to any specific screen
/// (e.g. image paths for images that are being uploaded)
/// MUST BE CLEARED WHEN NOT IN USE
class TempStateProvider extends ChangeNotifier {

  List<String>? _imagePaths;
  List<String> get imagePaths => _imagePaths ?? [];

  void setImagePaths(List<String> paths) {
    _imagePaths = paths;
    notifyListeners();
  }

  void removeImagePath(String path) {
    _imagePaths!.remove(path);
    notifyListeners();
  }

  void clearAllTempData() {
    debugPrint('----------------------------------- Clearing all temp data');
    _imagePaths = [];
    notifyListeners();
  }

}
