import 'dart:io';
import 'package:flutter/material.dart';
import 'package:bart_app/common/utility/bart_image_tools.dart';

class ImageWithPopUpMenu extends StatelessWidget {
  const ImageWithPopUpMenu({
    super.key,
    required this.imagePath,
    required this.onDelete,
  });

  final String imagePath;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: MenuAnchor(
        alignmentOffset: const Offset(25, 0),
        style: MenuStyle(
          padding: const WidgetStatePropertyAll(EdgeInsets.all(0)),
          backgroundColor:
              WidgetStatePropertyAll(Theme.of(context).colorScheme.surface),
        ),
        controller: MenuController(),
        builder: (context, controller, child) => InkWell(
          onTap: () {
            BartImageTools.viewImage(context, imagePath);
          },
          onLongPress: () {
            !controller.isOpen ? controller.open() : controller.close();
          },
          child: Container(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.file(
              File(imagePath),
              width: 150,
              height: 150,
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        menuChildren: [
          MenuItemButton(
            onPressed: onDelete,
            trailingIcon: Text(
              "delete",
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
            ),
            child: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
