import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bart_app/styles/bart_shimmer_load_style.dart';

class ProfileInfoHeaderShimmer extends StatelessWidget {
  const ProfileInfoHeaderShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    
    final shimmerStyle = Theme.of(context).extension<BartShimmerLoadStyle>()!;
    
    return Shimmer.fromColors(
      baseColor: shimmerStyle.baseColor,  
      highlightColor: shimmerStyle.highlightColor,
      child: Column(
        children: [
          Container(
            width: 100.w,
            height: 100.h,
            margin: EdgeInsets.only(top: 70.h),
            decoration: BoxDecoration(
              color: shimmerStyle.baseColor,
              borderRadius: BorderRadius.circular(50.r),
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            color: shimmerStyle.baseColor,
            width: 150.w,
            height: 30.h,
          ),
        ],
      ),
    );
  }
}
