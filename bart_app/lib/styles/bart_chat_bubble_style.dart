
import 'package:flutter/material.dart';

class BartChatBubbleStyle extends ThemeExtension<BartChatBubbleStyle>{

  BartChatBubbleStyle({
    required this.senderBackgroundColor,
    required this.receiverBackgroundColor,
    required this.senderTextColor,
    required this.receiverTextColor,
    required this.textStyle,
  });

  final Color senderBackgroundColor;
  final Color receiverBackgroundColor;
  final Color senderTextColor;
  final Color receiverTextColor;
  final TextStyle textStyle;


  @override
  ThemeExtension<BartChatBubbleStyle> copyWith({
    Color? senderBackgroundColor,
    Color? receiverBackgroundColor,
    Color? senderTextColor,
    Color? receiverTextColor,
    TextStyle? textStyle,
  }) => BartChatBubbleStyle(
    senderBackgroundColor: senderBackgroundColor ?? this.senderBackgroundColor,
    receiverBackgroundColor: receiverBackgroundColor ?? this.receiverBackgroundColor,
    senderTextColor: senderTextColor ?? this.senderTextColor,
    receiverTextColor: receiverTextColor ?? this.receiverTextColor,
    textStyle: textStyle ?? this.textStyle,
  );

  @override
  ThemeExtension<BartChatBubbleStyle> lerp(covariant ThemeExtension<BartChatBubbleStyle>? other, double t) {
    if (other == null) return this;
    if (other is BartChatBubbleStyle) {
      return BartChatBubbleStyle(
        senderBackgroundColor: Color.lerp(senderBackgroundColor, other.senderBackgroundColor, t)!,
        receiverBackgroundColor: Color.lerp(receiverBackgroundColor, other.receiverBackgroundColor, t)!,
        senderTextColor: Color.lerp(senderTextColor, other.senderTextColor, t)!,
        receiverTextColor: Color.lerp(receiverTextColor, other.receiverTextColor, t)!,
        textStyle: TextStyle.lerp(textStyle, other.textStyle, t)!,
      );
    }
    return this;
  }

}
