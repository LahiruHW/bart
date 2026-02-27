import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bart_app/common/widgets/bart_snackbar.dart';
import 'package:bart_app/common/utility/bart_image_tools.dart';
import 'package:bart_app/common/providers/temp_state_provider.dart';

class ImageOptionBottomModalSheet {
  ImageOptionBottomModalSheet({
    required this.parentContext,
    required this.tempProvider,
    required this.maxImgCount,
  });

  final BuildContext parentContext;
  final TempStateProvider tempProvider;
  final int maxImgCount;

  /// Opens the gallery to pick mutiple images
  void onGalleryPick() {
    BartImageTools.pickImagesFromGallery().then(
      (imgList) {
        final tempLst = [...tempProvider.images, ...imgList];
        if (tempLst.length > maxImgCount) {
          ScaffoldMessenger.of(parentContext).showSnackBar(
            BartSnackBar(
              message: tr(
                'image.picker.snackbar',
                namedArgs: {
                  'maxImgCount': maxImgCount.toString(),
                },
              ),
              backgroundColor: Colors.red,
              icon: Icons.error,
            ).build(parentContext),
          );
          tempLst.removeRange(maxImgCount, tempLst.length);
        }
        tempProvider.setImages(tempLst);
      },
    );
  }

  /// Opens the camera to take one photo
  void onCameraPick() {
    BartImageTools.captureImage(maxImgCount).then(
      (imgList) {
        final tempLst = [...tempProvider.images, ...imgList];
        if (tempLst.length > maxImgCount) {
          ScaffoldMessenger.of(parentContext).showSnackBar(
            BartSnackBar(
              message: tr(
                'image.picker.snackbar',
                namedArgs: {
                  'maxImgCount': maxImgCount.toString(),
                },
              ),
              backgroundColor: Colors.red,
              icon: Icons.error,
            ).build(parentContext),
          );
          tempLst.removeRange(maxImgCount, tempLst.length);
        }
        tempProvider.setImages(tempLst);
      },
    );
  }

  void show() {
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Theme.of(parentContext).bottomSheetTheme.backgroundColor,
      builder: (context) {
        return Wrap(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 20.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ListTile(
                    tileColor: Theme.of(context).bottomSheetTheme.backgroundColor,
                    leading: const Icon(Icons.camera_alt),
                    title: Text(
                      context.tr('item.img.from.camera'),
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontSize: 18.spMin,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    onTap: () {
                      Navigator.of(parentContext).pop();
                      onCameraPick();
                    },
                  ),
                  ListTile(
                    tileColor: Theme.of(context).bottomSheetTheme.backgroundColor,
                    leading: const Icon(Icons.photo),
                    title: Text(
                      context.tr('item.img.from.gallery'),
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontSize: 18.spMin,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    onTap: () {
                      Navigator.of(parentContext).pop();
                      onGalleryPick();
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
