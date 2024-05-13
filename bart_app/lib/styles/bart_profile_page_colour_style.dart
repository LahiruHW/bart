
import 'package:flutter/material.dart';

class BartProfilePageColourStyle extends ThemeExtension<BartProfilePageColourStyle>{
  
  BartProfilePageColourStyle({
    required this.gradientColourTop,
    required this.gradientColourBottom,
    required this.containerColor,
    required this.profileInfoCardColor,
    required this.textColor,
  });

  final Color gradientColourTop;
  final Color gradientColourBottom;
  final Color containerColor;
  final Color profileInfoCardColor;
  final Color textColor;
  
  
  @override
  ThemeExtension<BartProfilePageColourStyle> copyWith({
    Color? gradientColourTop,
    Color? gradientColourBottom,
    Color? containerColor,
    Color? profileInfoCardColor,
    Color? textColor,
  }) {
    return BartProfilePageColourStyle(
      gradientColourTop: gradientColourTop ?? this.gradientColourTop,
      gradientColourBottom: gradientColourBottom ?? this.gradientColourBottom,
      containerColor: containerColor ?? this.containerColor,
      profileInfoCardColor: profileInfoCardColor ?? this.profileInfoCardColor,
      textColor: textColor ?? this.textColor,
    );
  }

  @override
  ThemeExtension<BartProfilePageColourStyle> lerp(covariant ThemeExtension<BartProfilePageColourStyle>? other, double t) {
    if (other == null) {
      return this;
    }
    if (other is BartProfilePageColourStyle) {
      return BartProfilePageColourStyle(
        gradientColourTop: Color.lerp(gradientColourTop, other.gradientColourTop, t)!,
        gradientColourBottom: Color.lerp(gradientColourBottom, other.gradientColourBottom, t)!,
        containerColor: Color.lerp(containerColor, other.containerColor, t)!,
        profileInfoCardColor: Color.lerp(profileInfoCardColor, other.profileInfoCardColor, t)!,
        textColor: Color.lerp(textColor, other.textColor, t)!,
      );
    }
    return this;
  }
  
}
