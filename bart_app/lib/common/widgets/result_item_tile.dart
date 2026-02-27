import 'package:flutter/material.dart';
import 'package:bart_app/common/entity/item.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bart_app/common/utility/bart_image_tools.dart';
import 'package:cached_network_image/cached_network_image.dart';

// ignore: must_be_immutable
class ResultItemTile extends StatefulWidget {
  ResultItemTile({
    super.key,
    required this.label,
    required this.item,
    required this.onTap,
  });

  Item item;
  String label;
  VoidCallback? onTap;

  @override
  State<ResultItemTile> createState() => _ResultItemTileState();
}

class _ResultItemTileState extends State<ResultItemTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap ?? () {},
      child: Container(
        key: widget.key,
        margin: const EdgeInsets.symmetric(horizontal: 25),
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.computeLuminance() > 0.5
              ? Colors.white
              : Colors.black,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.black.withOpacity(0.2),
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                widget.label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context)
                                  .colorScheme
                                  .surface
                                  .computeLuminance() >
                              0.5
                          ? Colors.black
                          : Colors.white,
                      fontSize: 16.spMin,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            Expanded(
              flex: 1,
              child: !widget.item.isPayment
                  ? Container(
                      alignment: Alignment.center,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: CachedNetworkImage(
                        key: UniqueKey(),
                        cacheManager: BartImageTools.customCacheManager,
                        progressIndicatorBuilder: BartImageTools.progressLoader,
                        width: 90,
                        height: 90,
                        imageUrl: widget.item.imgs[0],
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      alignment: Alignment.center,
                      clipBehavior: Clip.antiAlias,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        widget.item.itemName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 25.spMin,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
