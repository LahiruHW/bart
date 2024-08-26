import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bart_app/common/widgets/shimmer/shimmer_market_list_tile.dart';

class MarketListTileListShimmer extends StatelessWidget {
  const MarketListTileListShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 10,
      separatorBuilder: (context, index) => Divider(
        height: 8.h,
        color: Colors.transparent,
      ),
      itemBuilder: (context, index) {
        return const MarketListTileShimmer(cardHeight: 130);
      },
    );
  }
}
