import 'package:flutter/material.dart';

class BartShimmerLoadStyle extends ThemeExtension<BartShimmerLoadStyle> {
  BartShimmerLoadStyle({
    required this.baseColor,
    required this.highlightColor,
  });

  final Color baseColor;
  final Color highlightColor;

  @override
  ThemeExtension<BartShimmerLoadStyle> copyWith({
    Color? baseColor,
    Color? highlightColor,
  }) {
    return BartShimmerLoadStyle(
      baseColor: baseColor ?? this.baseColor,
      highlightColor: highlightColor ?? this.highlightColor,
    );
  }

  @override
  ThemeExtension<BartShimmerLoadStyle> lerp(
      covariant ThemeExtension<BartShimmerLoadStyle>? other, double t) {
    if (other == null) {
      return this;
    }
    if (other is BartShimmerLoadStyle) {
      return BartShimmerLoadStyle(
        baseColor: Color.lerp(baseColor, other.baseColor, t)!,
        highlightColor: Color.lerp(highlightColor, other.highlightColor, t)!,
      );
    }
    return this;
  }
}
