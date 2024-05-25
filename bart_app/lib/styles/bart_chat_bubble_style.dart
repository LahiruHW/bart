import 'package:flutter/material.dart';

class BartChatBubbleStyle extends ThemeExtension<BartChatBubbleStyle> {
  BartChatBubbleStyle({
    required this.senderBackgroundColor,
    required this.receiverBackgroundColor,
    required this.senderTextColor,
    required this.receiverTextColor,
    required this.textStyle,
    required this.senderContextBackgroundColor,
    required this.receiverContextBackgroundColor,
    required this.senderContextTextColor,
    required this.receiverContextTextColor,
  });

  final Color senderBackgroundColor;
  final Color receiverBackgroundColor;
  final Color senderTextColor;
  final Color receiverTextColor;
  final TextStyle textStyle;

  final Color senderContextBackgroundColor;
  final Color receiverContextBackgroundColor;
  final Color senderContextTextColor;
  final Color receiverContextTextColor;

  @override
  ThemeExtension<BartChatBubbleStyle> copyWith({
    Color? senderBackgroundColor,
    Color? receiverBackgroundColor,
    Color? senderTextColor,
    Color? receiverTextColor,
    TextStyle? textStyle,
    Color? senderContextBackgroundColor,
    Color? receiverContextBackgroundColor,
    Color? senderContextTextColor,
    Color? receiverContextTextColor,
  }) =>
      BartChatBubbleStyle(
        senderBackgroundColor:
            senderBackgroundColor ?? this.senderBackgroundColor,
        receiverBackgroundColor:
            receiverBackgroundColor ?? this.receiverBackgroundColor,
        senderTextColor: senderTextColor ?? this.senderTextColor,
        receiverTextColor: receiverTextColor ?? this.receiverTextColor,
        textStyle: textStyle ?? this.textStyle,
        senderContextBackgroundColor:
            senderContextBackgroundColor ?? this.senderContextBackgroundColor,
        receiverContextBackgroundColor: receiverContextBackgroundColor ??
            this.receiverContextBackgroundColor,
        senderContextTextColor:
            senderContextTextColor ?? this.senderContextTextColor,
        receiverContextTextColor:
            receiverContextTextColor ?? this.receiverContextTextColor,
      );

  @override
  ThemeExtension<BartChatBubbleStyle> lerp(
      covariant ThemeExtension<BartChatBubbleStyle>? other, double t) {
    if (other == null) return this;
    if (other is BartChatBubbleStyle) {
      return BartChatBubbleStyle(
        senderBackgroundColor:
            Color.lerp(senderBackgroundColor, other.senderBackgroundColor, t)!,
        receiverBackgroundColor: Color.lerp(
            receiverBackgroundColor, other.receiverBackgroundColor, t)!,
        senderTextColor: Color.lerp(senderTextColor, other.senderTextColor, t)!,
        receiverTextColor:
            Color.lerp(receiverTextColor, other.receiverTextColor, t)!,
        textStyle: TextStyle.lerp(textStyle, other.textStyle, t)!,
        senderContextBackgroundColor: Color.lerp(senderContextBackgroundColor,
            other.senderContextBackgroundColor, t)!,
        receiverContextBackgroundColor: Color.lerp(
            receiverContextBackgroundColor,
            other.receiverContextBackgroundColor,
            t)!,
        senderContextTextColor: Color.lerp(
            senderContextTextColor, other.senderContextTextColor, t)!,
        receiverContextTextColor: Color.lerp(
            receiverContextTextColor, other.receiverContextTextColor, t)!,
      );
    }
    return this;
  }
}
