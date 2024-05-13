import 'package:bart_app/common/widgets/shimmer/shimmer_market_list_tile.dart';
import 'package:flutter/material.dart';

class MarketListTileListShimmer extends StatelessWidget {
  const MarketListTileListShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 10,
      separatorBuilder: (context, index) => const Divider(
        height: 8,
        color: Colors.transparent,
      ),
      itemBuilder: (context, index) {
        return const MarketListTileShimmer(cardHeight: 130);
      },
    );
  }
}
