
import 'package:flutter/material.dart';

/// used to store temporary state that is not related to any specific screen
/// (e.g. image paths for images that are being uploaded)
/// MUST BE CLEARED WHEN NOT IN USE
class TempStateProvider extends ChangeNotifier {

  List<String>? _imagePaths;
  String? _marketSearchText;
  Set<int>? _homeV2Index; 

  List<String> get imagePaths => _imagePaths ?? [];
  set imagePaths(List<String> imgs) => _imagePaths = imgs;

  String get searchText => _marketSearchText ?? '';
  set searchText(String searchTxt) => _marketSearchText = searchTxt;

  Set<int> get homeV2Index => _homeV2Index ?? {0};
  set homeV2Index(Set<int> index) => _homeV2Index = index;

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

  void setSearchText(String text) {
    _marketSearchText = text;
    notifyListeners();
  }

  void setHomeV2Index(Set<int> values) {
    _homeV2Index = values;
    notifyListeners();
  }

}
