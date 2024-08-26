import 'package:flutter/material.dart';

class BartSegmentSliderStyle extends ThemeExtension<BartSegmentSliderStyle> {
  BartSegmentSliderStyle({
    required this.iconColour,
    required this.selectedIconColour,
    required this.thumbColor,
    required this.backgroundColor,
  });

  final Color iconColour;
  final Color selectedIconColour;
  final Color thumbColor;
  final Color backgroundColor;

  @override
  ThemeExtension<BartSegmentSliderStyle> copyWith({
    Color? iconColour,
    Color? selectedIconColour,
    Color? thumbColor,
    Color? backgroundColor,
  }) {
    return BartSegmentSliderStyle(
      iconColour: iconColour ?? this.iconColour,
      selectedIconColour: selectedIconColour ?? this.selectedIconColour,
      thumbColor: thumbColor ?? this.thumbColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  @override
  ThemeExtension<BartSegmentSliderStyle> lerp(
    covariant ThemeExtension<BartSegmentSliderStyle>? other,
    double t,
  ) {
    if (other == null) {
      return this;
    }
    if (other is BartSegmentSliderStyle) {
      return BartSegmentSliderStyle(
        iconColour: Color.lerp(iconColour, other.iconColour, t)!,
        selectedIconColour: Color.lerp(selectedIconColour, other.selectedIconColour, t)!,
        thumbColor: Color.lerp(thumbColor, other.thumbColor, t)!,
        backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      );
    }
    return this;
  }
}
