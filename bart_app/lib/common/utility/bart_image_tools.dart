import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

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

  static Future<List<String>> captureImage(int maxImgCount) async {
    // IMPLEMENT FUNCTION HERE
    final returnedImages = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    return [returnedImages!.path];
  }

  static void viewImage(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Uri.parse(imagePath).isAbsolute
              ? CachedNetworkImage(
                  key: UniqueKey(),
                  imageUrl: imagePath,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: BartImageTools.progressLoader,
                )
              : Image.file(
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

  static final customCacheManager = CacheManager(
    Config(
      'bartImageCache',
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 150,
    ),
  );

  static Widget progressLoader(
    BuildContext context,
    String url,
    DownloadProgress dp,
  ) {
    if (dp.totalSize == null) {
      return const SizedBox();
    }
    return Center(
      child: CircularProgressIndicator(
        strokeCap: StrokeCap.round,
        value: dp.progress,
        valueColor: const AlwaysStoppedAnimation<Color>(
          Colors.red,
        ),
        strokeWidth: 1.0,
      ),
    );
  }
}

extension ImageExtension on num {
  int cacheSize(BuildContext context) {
    return (this * MediaQuery.of(context).devicePixelRatio).round();
  }
}
