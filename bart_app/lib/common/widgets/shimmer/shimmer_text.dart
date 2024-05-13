import 'package:bart_app/styles/bart_shimmer_load_style.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BartTextShimmer extends StatelessWidget {
  const BartTextShimmer({
    super.key,
    required this.textHeight,
    required this.textLength,
  });

  final double textHeight;
  final double textLength;

  @override
  Widget build(BuildContext context) {
    final shimmerStyle = Theme.of(context).extension<BartShimmerLoadStyle>()!;
    return Shimmer.fromColors(
      baseColor: shimmerStyle.baseColor,
      highlightColor: shimmerStyle.highlightColor,
      child: Container(
        width: textLength,
        height: textHeight,
        color: shimmerStyle.highlightColor,
      ),
    );
  }
}
