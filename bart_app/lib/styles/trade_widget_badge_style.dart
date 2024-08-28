import 'package:flutter/material.dart';

class TradeWidgetBadgeStyle extends ThemeExtension<TradeWidgetBadgeStyle> {
  TradeWidgetBadgeStyle({
    required this.badgeColor,
    required this.selectedBadgeColor,
    required this.labelColor,
    required this.selectedLabelColor,
    // required this.
  });

  final Color badgeColor;
  final Color selectedBadgeColor;
  final Color labelColor;
  final Color selectedLabelColor;

  @override
  ThemeExtension<TradeWidgetBadgeStyle> copyWith({
    Color? badgeColor,
    Color? selectedBadgeColor,
    Color? labelColor,
    Color? selectedLabelColor,
  }) {
    return TradeWidgetBadgeStyle(
      badgeColor: badgeColor ?? this.badgeColor,
      selectedBadgeColor: selectedBadgeColor ?? this.selectedBadgeColor,
      labelColor: labelColor ?? this.labelColor,
      selectedLabelColor: selectedLabelColor ?? this.selectedLabelColor,
    );
  }

  @override
  ThemeExtension<TradeWidgetBadgeStyle> lerp(
    covariant ThemeExtension<TradeWidgetBadgeStyle>? other,
    double t,
  ) {
    if (other == null) return this;
    if (other is TradeWidgetBadgeStyle) {
      return TradeWidgetBadgeStyle(
        badgeColor: Color.lerp(badgeColor, other.badgeColor, t)!,
        selectedBadgeColor:
            Color.lerp(selectedBadgeColor, other.selectedBadgeColor, t)!,
        labelColor: Color.lerp(labelColor, other.labelColor, t)!,
        selectedLabelColor:
            Color.lerp(selectedLabelColor, other.selectedLabelColor, t)!,
      );
    }
    return this;
  }
}
