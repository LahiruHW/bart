import 'package:flutter/material.dart';

class BartMarketListItemStyle extends ThemeExtension<BartMarketListItemStyle> {
  BartMarketListItemStyle({
    required this.splashColor,
    required this.titleColor,
    required this.cardTheme,
  });

  final Color splashColor;
  final Color titleColor;
  final CardTheme cardTheme;

  @override
  ThemeExtension<BartMarketListItemStyle> copyWith({
    Color? splashColor,
    Color? titleColor,
    CardTheme? cardTheme,
  }) {
    return BartMarketListItemStyle(
      splashColor: splashColor ?? this.splashColor,
      titleColor: titleColor ?? this.titleColor,
      cardTheme: cardTheme ?? this.cardTheme,
    );
  }

  @override
  ThemeExtension<BartMarketListItemStyle> lerp(
    covariant ThemeExtension<BartMarketListItemStyle>? other,
    double t,
  ) {
    if (other == null) {
      return this;
    }

    if (other is BartMarketListItemStyle) {
      return BartMarketListItemStyle(
        splashColor: Color.lerp(splashColor, other.splashColor, t)!,
        titleColor: Color.lerp(titleColor, other.titleColor, t)!,
        cardTheme: CardTheme.lerp(cardTheme, other.cardTheme, t),
      );
    }

    return this;
  }
}
