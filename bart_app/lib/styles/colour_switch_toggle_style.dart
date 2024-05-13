import 'package:flutter/material.dart';

class BartThemeModeToggleStyle
    extends ThemeExtension<BartThemeModeToggleStyle> {
  BartThemeModeToggleStyle({
    required this.iconColor,
    required this.backgroundColor,
    required this.indicatorColor,
  });

  final Color iconColor;
  final Color backgroundColor;
  final Color indicatorColor;

  @override
  ThemeExtension<BartThemeModeToggleStyle> copyWith({
    Color? iconColor,
    Color? backgroundColor,
    Color? indicatorColor,
  }) {
    return BartThemeModeToggleStyle(
      iconColor: iconColor ?? this.iconColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      indicatorColor: indicatorColor ?? this.indicatorColor,
    );
  }

  @override
  ThemeExtension<BartThemeModeToggleStyle> lerp(
      covariant ThemeExtension<BartThemeModeToggleStyle>? other, double t) {
    if (other == null) {
      return this;
    }

    if (other is BartThemeModeToggleStyle) {
      return BartThemeModeToggleStyle(
        iconColor: Color.lerp(iconColor, other.iconColor, t)!,
        backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
        indicatorColor: Color.lerp(indicatorColor, other.indicatorColor, t)!,
      );
    }

    return this;
  }
}
