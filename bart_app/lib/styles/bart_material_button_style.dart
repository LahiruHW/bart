import 'package:flutter/material.dart';

class BartMaterialButtonStyle extends ThemeExtension<BartMaterialButtonStyle> {
  BartMaterialButtonStyle({
    required this.backgroundColor,
    required this.splashColor,
    required this.textColor,
    required this.elevatedShadowColor,
  });

  final Color backgroundColor;
  final Color splashColor;
  final Color textColor;
  final Color elevatedShadowColor;

  @override
  ThemeExtension<BartMaterialButtonStyle> copyWith({
    double? elevation,
    Color? backgroundColor,
    Color? splashColor,
    Color? textColor,
    Color? elevatedShadowColor,
  }) {
    return BartMaterialButtonStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      splashColor: splashColor ?? this.splashColor,
      textColor: textColor ?? this.textColor,
      elevatedShadowColor: elevatedShadowColor ?? this.elevatedShadowColor,
    );
  }

  @override
  ThemeExtension<BartMaterialButtonStyle> lerp(
    covariant ThemeExtension<BartMaterialButtonStyle>? other,
    double t,
  ) {
    if (other == null) {
      return this;
    }

    if (other is BartMaterialButtonStyle) {
      return BartMaterialButtonStyle(
        backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
        splashColor: Color.lerp(splashColor, other.splashColor, t)!,
        textColor: Color.lerp(textColor, other.textColor, t)!,
        elevatedShadowColor:
            Color.lerp(elevatedShadowColor, other.elevatedShadowColor, t)!,
      );
    }

    return this;
  }
}

// //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class BartMaterialButtonStyleGreen
    extends ThemeExtension<BartMaterialButtonStyleGreen> {
  BartMaterialButtonStyleGreen({this.buttonStyle});

  final BartMaterialButtonStyle? buttonStyle;

  @override
  ThemeExtension<BartMaterialButtonStyleGreen> copyWith({
    BartMaterialButtonStyle? buttonStyle,
  }) {
    return BartMaterialButtonStyleGreen(
      buttonStyle: buttonStyle ?? this.buttonStyle,
    );
  }

  @override
  ThemeExtension<BartMaterialButtonStyleGreen> lerp(
    covariant ThemeExtension<BartMaterialButtonStyleGreen>? other,
    double t,
  ) {
    if (other == null) {
      return this;
    }

    if (other is BartMaterialButtonStyleGreen) {
      return BartMaterialButtonStyleGreen(
        buttonStyle:
            buttonStyle!.lerp(other.buttonStyle, t) as BartMaterialButtonStyle?,
      );
    }

    return this;
  }
}
