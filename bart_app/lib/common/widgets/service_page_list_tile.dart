import 'package:bart_app/styles/market_list_item_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServicePageListTile extends StatelessWidget {
  const ServicePageListTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cardStyle = Theme.of(context).extension<BartMarketListItemStyle>()!;
    final cardHeight = 115.h;

    return Card(
      elevation: 7,
      color: cardStyle.cardTheme.color,
      shape: cardStyle.cardTheme.shape,
      margin: cardStyle.cardTheme.margin,
      clipBehavior: cardStyle.cardTheme.clipBehavior,
      surfaceTintColor: cardStyle.cardTheme.surfaceTintColor,
      child: InkWell(
        onTap: () => debugPrint('------------- TAPPED SERVICE TILE'),
        onLongPress: () {},
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
                        'SERVICE NAME',
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
                        'SERVICE NAME',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.spMin,
                            ),
                      ),
                      Text(
                        'TIME',
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
              // SizedBox(
              //   height: cardHeight.h,
              //   child: AspectRatio(
              //     aspectRatio: 1.0,
              //     child: Padding(
              //       padding: const EdgeInsets.all(10.0),
              //       child: CachedNetworkImage(
              //         key: UniqueKey(),
              //         cacheKey: 'item_${item.itemID}_0',
              //         imageUrl: item.imgs[0],
              //         cacheManager: BartImageTools.customCacheManager,
              //         fit: BoxFit.contain,
              //         progressIndicatorBuilder: BartImageTools.progressLoader,
              //         errorWidget: (context, url, error) =>
              //             const Icon(Icons.error),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
