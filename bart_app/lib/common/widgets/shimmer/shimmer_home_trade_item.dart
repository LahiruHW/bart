import 'package:bart_app/styles/bart_shimmer_load_style.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerHomeTradeWidget extends StatelessWidget {
  const ShimmerHomeTradeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final shimmerStyle = Theme.of(context).extension<BartShimmerLoadStyle>()!;

    return Shimmer.fromColors(
      baseColor: shimmerStyle.baseColor,
      highlightColor: shimmerStyle.highlightColor,
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 10,
          left: 10,
          right: 10,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 12.0,
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 6,
              child: Container(
                width: 100,
                height: 10,
                color: shimmerStyle.highlightColor,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: Container(
                width: 100,
                height: 10,
                color: shimmerStyle.highlightColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
