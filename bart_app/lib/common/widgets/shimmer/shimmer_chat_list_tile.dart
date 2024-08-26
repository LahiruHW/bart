import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bart_app/styles/bart_shimmer_load_style.dart';

class ChatListTileShimmer extends StatelessWidget {
  const ChatListTileShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final shimmerStyle = Theme.of(context).extension<BartShimmerLoadStyle>()!;
    return Shimmer.fromColors(
      baseColor: shimmerStyle.baseColor,
      highlightColor: shimmerStyle.highlightColor,
      child: ListTile(
        tileColor: shimmerStyle.baseColor.withOpacity(0.2),
        title: Container(
          color: shimmerStyle.baseColor,
          width: 80.w,
          height: 10.h,
        ),
        subtitle: Container(
          color: shimmerStyle.baseColor,
          width: 50.w,
          height: 10.h,
        ),
        leading: CircleAvatar(
          backgroundColor: shimmerStyle.baseColor,
          radius: 30.w,
          child: const Icon(Icons.person),
        ),
        trailing: Container(
          color: shimmerStyle.baseColor,
          width: 30.w,
          height: 10.h,
        ),
        minLeadingWidth: 10.w,
        style: ListTileStyle.drawer,
      ),
    );
  }
}
