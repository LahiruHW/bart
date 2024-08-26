import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bart_app/styles/bart_shimmer_load_style.dart';

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
          top: 2,
          bottom: 10,
          left: 12,
          right: 12,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 18.h,
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(7.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 7,
              child: Container(
                width: 100.w,
                height: 10.h,
                color: shimmerStyle.highlightColor,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              flex: 1,
              child: Container(
                width: 100.w,
                height: 10.h,
                color: shimmerStyle.highlightColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
