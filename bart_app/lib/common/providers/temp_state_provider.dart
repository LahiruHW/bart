import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// used to store temporary state that is not related to any specific screen
/// (e.g. image paths for images that are being uploaded)
/// MUST BE CLEARED WHEN NOT IN USE
class TempStateProvider extends ChangeNotifier {
  List<XFile>? _images;
  String? _marketSearchText;
  int? _homeV2Index;

  List<String> get imagePaths => List<String>.from(
        (_images ?? []).map((i) => i.path),
      );
  List<XFile> get images => _images ?? [];
  set images(List<XFile> imgs) => _images = imgs;

  String get searchText => _marketSearchText ?? '';
  set searchText(String searchTxt) => _marketSearchText = searchTxt;

  int get homeV2Index => _homeV2Index ?? 0;
  set homeV2Index(int index) => _homeV2Index = index;

  void setImages(List<XFile> paths) {
    _images = paths;
    notifyListeners();
  }

  void removeImagePath(String path) {
    _images!.remove(path);
    notifyListeners();
  }

  void clearAllTempData() {
    debugPrint('----------------------------------- Clearing all temp data');
    _images = [];
    notifyListeners();
  }

  void setSearchText(String text) {
    _marketSearchText = text;
    notifyListeners();
  }

  void setHomeV2Index(int value) {
    _homeV2Index = value;
    notifyListeners();
  }
}
