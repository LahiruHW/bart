import 'package:flutter/material.dart';

class BartPaymentPageStyle extends ThemeExtension<BartPaymentPageStyle> {
  BartPaymentPageStyle({
    required this.currencyDropdownBackgroundColor,
    required this.currencyDropdownTextColor,
    required this.currencyDropdownIconColor,
    required this.textFieldBackgroundColor,
    required this.textFieldTextColor,
  });

  final Color currencyDropdownBackgroundColor;
  final Color currencyDropdownTextColor;
  final Color currencyDropdownIconColor;
  final Color textFieldBackgroundColor;
  final Color textFieldTextColor;

  @override
  ThemeExtension<BartPaymentPageStyle> copyWith({
    Color? currencyDropdownBackgroundColor,
    Color? currencyDropdownTextColor,
    Color? currencyDropdownIconColor,
    Color? textFieldBackgroundColor,
    Color? textFieldTextColor,
  }) {
    return BartPaymentPageStyle(
      currencyDropdownBackgroundColor: currencyDropdownBackgroundColor ??
          this.currencyDropdownBackgroundColor,
      currencyDropdownTextColor:
          currencyDropdownTextColor ?? this.currencyDropdownTextColor,
      currencyDropdownIconColor:
          currencyDropdownIconColor ?? this.currencyDropdownIconColor,
      textFieldBackgroundColor:
          textFieldBackgroundColor ?? this.textFieldBackgroundColor,
      textFieldTextColor: textFieldTextColor ?? this.textFieldTextColor,
    );
  }

  @override
  ThemeExtension<BartPaymentPageStyle> lerp(
    covariant ThemeExtension<BartPaymentPageStyle>? other,
    double t,
  ) {
    if (other == null) {
      return this;
    }
    if (other is BartPaymentPageStyle) {
      return BartPaymentPageStyle(
        currencyDropdownBackgroundColor: Color.lerp(
            currencyDropdownBackgroundColor,
            other.currencyDropdownBackgroundColor,
            t)!,
        currencyDropdownTextColor: Color.lerp(
            currencyDropdownTextColor, other.currencyDropdownTextColor, t)!,
        currencyDropdownIconColor: Color.lerp(
            currencyDropdownIconColor, other.currencyDropdownIconColor, t)!,
        textFieldBackgroundColor: Color.lerp(
            textFieldBackgroundColor, other.textFieldBackgroundColor, t)!,
        textFieldTextColor:
            Color.lerp(textFieldTextColor, other.textFieldTextColor, t)!,
      );
    }
    return this;
  }
}
