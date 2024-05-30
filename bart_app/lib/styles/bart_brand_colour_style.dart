import 'package:flutter/material.dart';

class BartBrandColours extends ThemeExtension<BartBrandColours> {
  BartBrandColours({
    required this.logoColor,
    required this.logoBackgroundColor,
    required this.loginBtnTextColor,
    required this.loginBtnBackgroundColor,
  });

  final Color logoColor;
  final Color logoBackgroundColor;
  final Color loginBtnTextColor;
  final Color loginBtnBackgroundColor;

  @override
  ThemeExtension<BartBrandColours> copyWith({
    Color? logoColor,
    Color? logoBackgroundColor,
    Color? loginBtnTextColor,
    Color? loginBtnBackgroundColor,
  }) {
    return BartBrandColours(
      logoColor: logoColor ?? this.logoColor,
      logoBackgroundColor: logoBackgroundColor ?? this.logoBackgroundColor,
      loginBtnTextColor: loginBtnTextColor ?? this.loginBtnTextColor,
      loginBtnBackgroundColor:
          loginBtnBackgroundColor ?? this.loginBtnBackgroundColor,
    );
  }

  @override
  ThemeExtension<BartBrandColours> lerp(
    covariant ThemeExtension<BartBrandColours>? other,
    double t,
  ) {
    if (other == null) {
      return this;
    }
    if (other is BartBrandColours) {
      return BartBrandColours(
        logoColor: Color.lerp(logoColor, other.logoColor, t)!,
        logoBackgroundColor:
            Color.lerp(logoBackgroundColor, other.logoBackgroundColor, t)!,
        loginBtnTextColor:
            Color.lerp(loginBtnTextColor, other.loginBtnTextColor, t)!,
        loginBtnBackgroundColor: Color.lerp(
            loginBtnBackgroundColor, other.loginBtnBackgroundColor, t)!,
      );
    }
    return this;
  }
}
