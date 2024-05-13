import 'package:bart_app/styles/bart_shimmer_load_style.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

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
          // tileColor: Colors.grey[200]!,
          tileColor: shimmerStyle.baseColor.withOpacity(0.2),
          title: Container(
            // color: Colors.grey,
            color: shimmerStyle.baseColor,
            width: 80,
            height: 10,
          ),
          subtitle: Container(
            // color: Colors.grey,
            color: shimmerStyle.baseColor,
            width: 50,
            height: 10,
          ),
          leading: CircleAvatar(
            // backgroundColor: Colors.grey,
            backgroundColor: shimmerStyle.baseColor,
            radius: 30,
            child: const Icon(Icons.person),
          ),
          trailing: Container(
            // color: Colors.grey,
            color: shimmerStyle.baseColor,
            width: 30,
            height: 10,
          ),
          minLeadingWidth: 10,
          style: ListTileStyle.drawer,
        ));
  }
}
