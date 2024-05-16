import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:bart_app/common/widgets/image_with_popup.dart';
import 'package:bart_app/common/utility/bart_image_tools.dart';
import 'package:bart_app/common/providers/temp_state_provider.dart';

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
        // onTap: _imagePaths.length == 4
        onTap: provider.imagePaths.length == 4
            ? null
            : () => BartImageTools.pickImagesFromGallery().then((imgList) {
                  // final tempLst = [..._imagePaths, ...imgList];
                  final tempLst = [...provider.imagePaths, ...imgList];
      
                  if (tempLst.length > 4) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            // Text("You can only upload a maximum of 4 images"),
                            Text(tr('image.picker.snackbar')),
                      ),
                    );
                    tempLst.removeRange(4, tempLst.length);
                  }
      
                  // setState(() {
                  //   _imagePaths = tempLst;
                  // });
                  provider.setImagePaths(tempLst);

                }),
        child: Container(
          width: double.infinity,
          // padding: _imagePaths.isEmpty
          padding: provider.imagePaths.isEmpty
              ? const EdgeInsets.symmetric(vertical: 45)
              : const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 2.5,
                ),
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color:
                Theme.of(context).colorScheme.surface.computeLuminance() > 0.5
                    ? Colors.white
                    : Colors.black,
            border: Border.all(
              color: Colors.black.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          // child: _imagePaths.isEmpty
          child: provider.imagePaths.isEmpty
              ? Column(
                  children: [
                    const Icon(Icons.upload),
                    const SizedBox(height: 10),
                    Text(
                      // "Upload upto 4 pictures of your item you wish to exchange",
                      context.tr('image.picker.text'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
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
                      if (provider.imagePaths.length < 4) imgPlaceholder(),
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
      ),
    );
  }
}
