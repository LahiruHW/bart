import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:bart_app/common/constants/use_emulators.dart';
// import 'package:bart_app/common/utility/bart_image_tools.dart';

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
  static Future<String> uploadItemImage(XFile img, String itemID) async {
    final imgName = img.path.split('/').last;
    final type =
        (img.mimeType != null) ? '.${img.mimeType!.split('/').last}' : '';

    debugPrint("||||||||||||||| Image name (web): $imgName");

    final ref = itemFolderRef.child('$itemID/$imgName$type');
    final uploadTask = ref.putData(
      await img.readAsBytes(),
      SettableMetadata(contentType: img.mimeType),
    );
    final snapshot = await uploadTask.whenComplete(() => null);
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  // upload a list of images to a particular firebase storage folder - item/{item_id}/IMAGE_FILE_HERE
  static Future<List<String>> uploadItemImages(
    List<XFile> imgList,
    String itemID,
  ) async {
    // get a list of futures from the list of image paths
    final futureList =
        imgList.map((filePath) => uploadItemImage(filePath, itemID)).toList();
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
      });
    });
  }
}
