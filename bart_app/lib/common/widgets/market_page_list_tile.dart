import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:bart_app/common/entity/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bart_app/styles/market_list_item_style.dart';
import 'package:bart_app/common/utility/bart_image_tools.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MarketListTile extends StatelessWidget {
  const MarketListTile({
    super.key,
    required this.item,
    required this.onTap,
    this.onLongPress,
    this.cardHeight = 115,
  });

  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final double cardHeight;
  final Item item;

  String getTimeDifferenceString(Timestamp timestamp) {
    String retStr = 'published ';
    final DateFormat timeFormatter = DateFormat('hh:mma');
    final DateFormat dateFormatter = DateFormat('dd/MM/yyyy');
    final now = DateTime.now();
    final difference = now.difference(timestamp.toDate());

    // rewrite the logic, but change the order of the if statements
    if (difference.inMinutes < 1) {
      retStr += 'Just now';
    } else if (difference.inMinutes < 60) {
      retStr += '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      retStr += '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      retStr += '${difference.inDays} day ago';
    } else if (difference.inDays > 1 && difference.inDays < 21) {
      retStr += '${difference.inDays} days ago';
    } else {
      retStr += timeFormatter.format(timestamp.toDate());
      retStr += ' on ${dateFormatter.format(timestamp.toDate())}';
    }

    return retStr;
  }

  @override
  Widget build(BuildContext context) {
    final cardStyle = Theme.of(context).extension<BartMarketListItemStyle>()!;
    return GestureDetector(
      onSecondaryTap: onLongPress ?? () {},
      child: Card(
        elevation: 7,
        color: cardStyle.cardTheme.color,
        shape: cardStyle.cardTheme.shape,
        margin: cardStyle.cardTheme.margin,
        clipBehavior: cardStyle.cardTheme.clipBehavior,
        surfaceTintColor: cardStyle.cardTheme.surfaceTintColor,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress ?? () {},
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item.itemName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.headlineLarge!.copyWith(
                                    color: cardStyle.titleColor,
                                    fontSize: 23.spMin,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Divider(
                          height: 5.h,
                          color: Colors.transparent,
                        ),
                        Text(
                          'by ${item.itemOwner.userName}',
                          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 18.spMin,
                              ),
                        ),
                        Text(
                          getTimeDifferenceString(item.postedOn),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            fontSize: 14.spMin,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: cardHeight.h,
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CachedNetworkImage(
                        key: UniqueKey(),
                        cacheKey: 'item_${item.itemID}_0',
                        imageUrl: item.imgs[0],
                        cacheManager: BartImageTools.customCacheManager,
                        fit: BoxFit.contain,
                        progressIndicatorBuilder: BartImageTools.progressLoader,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
