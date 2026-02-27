import 'package:flutter/material.dart';

class BartScrollbarStyle extends ThemeExtension<BartScrollbarStyle> {
  final ScrollbarThemeData themeData;

  const BartScrollbarStyle({
    required this.themeData,
  });

  @override
  BartScrollbarStyle copyWith({
    ScrollbarThemeData? themeData,
  }) {
    return BartScrollbarStyle(
      themeData: themeData ?? this.themeData,
    );
  }

  @override
  BartScrollbarStyle lerp(ThemeExtension<BartScrollbarStyle>? other, double t) {
    if (other == null) {
      return this;
    }
    if (other is BartScrollbarStyle) {
      return BartScrollbarStyle(
        themeData: ScrollbarThemeData.lerp(themeData, other.themeData, t),
      );
    }
    return this;
  }
}
