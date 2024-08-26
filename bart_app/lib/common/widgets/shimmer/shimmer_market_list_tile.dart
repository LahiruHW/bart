import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bart_app/styles/market_list_item_style.dart';
import 'package:bart_app/styles/bart_shimmer_load_style.dart';

class MarketListTileShimmer extends StatelessWidget {
  const MarketListTileShimmer({
    super.key,
    this.cardHeight = 130,
  });

  final double cardHeight;

  @override
  Widget build(BuildContext context) {
    final cardStyle = Theme.of(context).extension<BartMarketListItemStyle>()!;
    final shimmerStyle = Theme.of(context).extension<BartShimmerLoadStyle>()!;
    return Card(
      elevation: 0,
      shape: cardStyle.cardTheme.shape,
      margin: cardStyle.cardTheme.margin,
      color: shimmerStyle.baseColor.withOpacity(0.2),
      child: Shimmer.fromColors(
        baseColor: shimmerStyle.baseColor,
        highlightColor: shimmerStyle.highlightColor,
        child: Padding(
          padding: EdgeInsets.only(left: 15.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // item name
                    Container(
                      color: shimmerStyle.baseColor,
                      width: 150.w,
                      height: 10.h,
                    ),
                    Divider(height: 10.h, color: Colors.transparent),
                    // username
                    Container(
                      color: Colors.grey,
                      width: 80.w,
                      height: 10.h,
                    ),
                    Divider(height: 10.h, color: Colors.transparent),
                    // date
                    Container(
                      color: shimmerStyle.baseColor,
                      width: double.infinity,
                      height: 10.h,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: cardHeight,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ColoredBox(color: shimmerStyle.baseColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
