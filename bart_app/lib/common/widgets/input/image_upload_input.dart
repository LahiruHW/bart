// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bart_app/common/widgets/image_with_popup.dart';
import 'package:bart_app/common/utility/bart_image_tools.dart';
import 'package:bart_app/common/providers/temp_state_provider.dart';

const int MAX_IMAGES = 4; // Maximum number of images that can be uploaded

class BartImagePicker extends StatefulWidget {
  const BartImagePicker({
    super.key,
  });

  @override
  State<BartImagePicker> createState() => _BartImagePickerState();
}

class _BartImagePickerState extends State<BartImagePicker> {
  // late List<String> _imagePaths = []; // List of image paths - a max of 4

  @override
  void initState() {
    super.initState();
  }

  Widget imgPlaceholder({
    bool? isUploadButton,
  }) {
    return Container(
      padding: const EdgeInsets.all(50),
      margin: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TempStateProvider>(
      builder: (context, provider, child) => GestureDetector(
        onTap: provider.imagePaths.length == MAX_IMAGES
            ? null
            : () => BartImageTools.pickImagesFromGallery().then(
                  (imgList) {
                    final tempLst = [...provider.imagePaths, ...imgList];

                    if (tempLst.length > MAX_IMAGES) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            tr('image.picker.snackbar'),
                          ),
                        ),
                      );
                      tempLst.removeRange(MAX_IMAGES, tempLst.length);
                    }
                    provider.setImagePaths(tempLst);
                  },
                ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 150,
              padding: provider.imagePaths.isEmpty
                  ? const EdgeInsets.symmetric(vertical: 45)
                  : const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 2.5,
                    ),
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color:
                    Theme.of(context).colorScheme.surface.computeLuminance() >
                            0.5
                        ? Colors.white
                        : Colors.black,
                border: Border.all(
                  color: Colors.black.withOpacity(0.2),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: provider.imagePaths.isEmpty
                  ? Column(
                      children: [
                        const Icon(Icons.upload),
                        const SizedBox(height: 10),
                        Text(
                          context.tr('image.picker.text'),
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  ),
                        ),
                      ],
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          // ..._imagePaths.map(
                          ...provider.imagePaths.map(
                            (img) => ImageWithPopUpMenu(
                              imagePath: img,
                              onDelete: () {
                                // setState(() => _imagePaths.remove(img));
                                provider.removeImagePath(img);
                              },
                            ),
                          ),
                          // if (_imagePaths.length < 4) imgPlaceholder(),
                          if (provider.imagePaths.length < MAX_IMAGES) imgPlaceholder(),
                        ]
                            .animate(
                              delay: 300.ms,
                              interval: 50.ms,
                            )
                            .fadeIn(
                              duration: 400.ms,
                              curve: Curves.easeInOutCubic,
                            ),
                      ),
                    ),
            ),
            provider.imagePaths.isNotEmpty
                ? Container(
                    margin: const EdgeInsets.only(bottom: 10, left: 2.5),
                    child: Text(
                      context.tr('image.picker.see.delete.btn'),
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontSize: 14),
                    ),
                  )
                : const SizedBox(height: 10)
          ],
        ),
      ),
    );
  }
}
