import 'dart:ui';
import 'package:flutter/material.dart';

class BartTabButtonStyle extends ThemeExtension<BartTabButtonStyle> {
  BartTabButtonStyle({
    required this.enabledElevation,
    required this.disabledElevation,
    required this.enabledBackgroundColor,
    required this.disabledBackgroundColor,
    required this.enabledForegroundColor,
    required this.disabledForegroundColor,
  });

  final double enabledElevation;
  final double disabledElevation;
  final Color enabledBackgroundColor;
  final Color disabledBackgroundColor;
  final Color enabledForegroundColor;
  final Color disabledForegroundColor;

  Color getBackgroundColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return disabledBackgroundColor;
    }
    return enabledBackgroundColor;
  }

  double getElevation(Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return disabledElevation;
    }
    return enabledElevation;
  }

  Color getForegroundColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return disabledForegroundColor;
    }
    return enabledForegroundColor;
  }

  @override
  ThemeExtension<BartTabButtonStyle> copyWith({
    double? enabledElevation,
    double? disabledElevation,
    Color? enabledBackgroundColor,
    Color? disabledBackgroundColor,
    Color? enabledForegroundColor,
    Color? disabledForegroundColor,
  }) {
    return BartTabButtonStyle(
        enabledElevation: enabledElevation ?? this.enabledElevation,
        disabledElevation: disabledElevation ?? this.disabledElevation,
        enabledBackgroundColor:
            enabledBackgroundColor ?? this.enabledBackgroundColor,
        disabledBackgroundColor:
            disabledBackgroundColor ?? this.disabledBackgroundColor,
        enabledForegroundColor:
            enabledForegroundColor ?? this.enabledForegroundColor,
        disabledForegroundColor:
            disabledForegroundColor ?? this.disabledForegroundColor);
  }

  @override
  ThemeExtension<BartTabButtonStyle> lerp(
      covariant ThemeExtension<BartTabButtonStyle>? other, double t) {
    if (other == null) {
      return this;
    }
    if (other is BartTabButtonStyle) {
      return BartTabButtonStyle(
        enabledElevation:
            lerpDouble(enabledElevation, other.enabledElevation, t)!,
        disabledElevation:
            lerpDouble(disabledElevation, other.disabledElevation, t)!,
        enabledBackgroundColor: Color.lerp(
            enabledBackgroundColor, other.enabledBackgroundColor, t)!,
        disabledBackgroundColor: Color.lerp(
            disabledBackgroundColor, other.disabledBackgroundColor, t)!,
        enabledForegroundColor: Color.lerp(
            enabledForegroundColor, other.enabledForegroundColor, t)!,
        disabledForegroundColor: Color.lerp(
            disabledForegroundColor, other.disabledForegroundColor, t)!,
      );
    }
    return this;
  }
}
