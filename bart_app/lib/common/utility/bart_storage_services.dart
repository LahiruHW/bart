import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:bart_app/common/constants/use_emulators.dart';

class BartFirebaseStorageServices {
  BartFirebaseStorageServices() {
    storage = FirebaseStorage.instance;
    if (FirebaseEmulatorService.useEmulators) {
      final host = Platform.isAndroid ? Platform.localHostname : "127.0.0.1";
      storage.useStorageEmulator(host, 9199);
      debugPrint('---------------------- using Storage Emulator at $host:9199');
    }
  }

  static late final FirebaseStorage storage;

  static final userProfileFolderRef = storage.ref().child('user_profile');

  static final itemFolderRef =
      storage.ref().child('item'); // item/{item_id}/IMAGES_HERE

  static final chatFolderRef = storage.ref().child('chat');

  // upload an image to a particular firebase storage folder - item/{item_id}/
  static Future<String> uploadItemImage(String imgPath, String itemID) async {
    // get the name of the image file from the path
    final imgName = imgPath.split('/').last;
    debugPrint("||||||||||||||| Image name: $imgName");

    final ref = itemFolderRef.child('$itemID/$imgName');
    final uploadTask = ref.putFile(File(imgPath));
    final snapshot = await uploadTask.whenComplete(() => null);
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  // upload a list of images to a particular firebase storage folder - item/{item_id}/IMAGE_FILE_HERE
  static Future<List<String>> uploadItemImages(
      List<String> imgPathList, String itemID) async {
    // get a list of futures from the list of image paths
    final futureList = imgPathList
        .map((filePath) => uploadItemImage(filePath, itemID))
        .toList();
    // wait for all the futures to complete and return the list of download urls
    return await Future.wait(futureList);
  }

  static Future<void> deleteAllItemImages(String itemID) async {
    final ref = itemFolderRef.child(itemID);
    await ref.listAll().then((result) {
      result.items.forEach((element) async {
        await storage
            .ref(element.fullPath)
            .delete()
            .then((value) => debugPrint("Deleted image: ${element.fullPath}"));
        // element.delete();
      });
    });
  }
}
