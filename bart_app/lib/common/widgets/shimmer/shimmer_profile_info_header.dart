import 'package:bart_app/styles/bart_shimmer_load_style.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

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
            width: 100,
            height: 100,
            margin: const EdgeInsets.only(top: 70.0),
            decoration: BoxDecoration(
              color: shimmerStyle.baseColor,
              borderRadius: BorderRadius.circular(50.0),
            ),
            // clipBehavior: Clip.hardEdge,
            // this should be a column with  [image, username]
            // child: CachedNetworkImage(
            //   imageUrl: stateProvider.userProfile.imageUrl!,
            //   fit: BoxFit.cover,
            // ),
          ),
          const SizedBox(height: 10.0),
          // Text(
          //   stateProvider.userProfile.userName,
          //   style: Theme.of(context).textTheme.labelLarge!.copyWith(
          //         fontSize: 30,
          //       ),
          // ),
          Container(
            color: shimmerStyle.baseColor,
            width: 150,
            height: 30,
          ),
        ],
      ),
    );
  }
}
