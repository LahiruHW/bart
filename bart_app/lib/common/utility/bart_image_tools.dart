import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BartImageTools {
  static Future<String> pickImageFromGallery() async {
    final returnedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    return returnedImage!.path;
  }

  static Future<List<String>> pickImagesFromGallery() async {
    final returnedImages = await ImagePicker().pickMultiImage(
      imageQuality: 50,
    );

    return returnedImages.map((e) => e.path).toList();
  }

  static void viewImage(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Image.file(
            File(imagePath),
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  // Future<void> getLostData() async {
  //   final ImagePicker picker = ImagePicker();
  //   final LostDataResponse response = await picker.retrieveLostData();
  //   if (response.isEmpty) {
  //     return;
  //   }
  //   final List<XFile>? files = response.files;
  //   if (files != null) {
  //     // _handleLostFiles(files);
  //     debugPrint('Lost files: $files');
  //   } else {
  //     // _handleError(response.exception);
  //     throw Exception('Lost data error');
  //   }
  // }
}
