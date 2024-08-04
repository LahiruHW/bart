import 'package:flutter/material.dart';

class BartTutorialContentStyle
    extends ThemeExtension<BartTutorialContentStyle> {
  BartTutorialContentStyle({
    required this.contentTextColour,
    required this.contentBackgroundColour,
    required this.overlayShadowColour,
    required this.buttonTextColor,
  });

  final Color contentTextColour;
  final Color contentBackgroundColour;
  final Color overlayShadowColour;
  final Color buttonTextColor;

  @override
  ThemeExtension<BartTutorialContentStyle> copyWith({
    Color? contentTextColour,
    Color? contentBackgroundColour,
    Color? overlayShadowColour,
    Color? buttonTextColor,
  }) {
    return BartTutorialContentStyle(
      contentTextColour: contentTextColour ?? this.contentTextColour,
      contentBackgroundColour:
          contentBackgroundColour ?? this.contentBackgroundColour,
      overlayShadowColour: overlayShadowColour ?? this.overlayShadowColour,
      buttonTextColor: buttonTextColor ?? this.buttonTextColor,
    );
  }

  @override
  ThemeExtension<BartTutorialContentStyle> lerp(
    covariant ThemeExtension<BartTutorialContentStyle>? other,
    double t,
  ) {
    if (other == null) {
      return this;
    }
    if (other is BartTutorialContentStyle) {
      return BartTutorialContentStyle(
        contentTextColour:
            Color.lerp(contentTextColour, other.contentTextColour, t) ??
                contentTextColour,
        contentBackgroundColour: Color.lerp(
                contentBackgroundColour, other.contentBackgroundColour, t) ??
            contentBackgroundColour,
        overlayShadowColour:
            Color.lerp(overlayShadowColour, other.overlayShadowColour, t) ??
                overlayShadowColour,
        buttonTextColor:
            Color.lerp(buttonTextColor, other.buttonTextColor, t) ??
                buttonTextColor,
      );
    }
    return this;
  }
}
