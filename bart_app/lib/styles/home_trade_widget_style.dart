import 'package:flutter/material.dart';

class BartTradeWidgetStyle extends ThemeExtension<BartTradeWidgetStyle> {
  BartTradeWidgetStyle({
    required this.incomingTextColour,
    required this.incomingBackgroundColour,
    required this.incomingShadowColour,
    required this.outgoingTextColour,
    required this.outgoingBackgroundColour,
    required this.outgoingShadowColour,
    required this.tbcTextColour,
    required this.tbcBackgroundColour,
    required this.tbcShadowColour,
    required this.completeFailTextColour,
    required this.completeFailBackgroundColour,
    required this.completeFailShadowColour,
    required this.tradeHistoryTextColour,
    required this.tradeHistoryBackgroundColour,
    required this.tradeHistoryShadowColour,
  });

  final Color incomingTextColour;
  final Color incomingBackgroundColour;
  final Color incomingShadowColour;
  final Color outgoingTextColour;
  final Color outgoingBackgroundColour;
  final Color outgoingShadowColour;
  final Color tbcTextColour;
  final Color tbcBackgroundColour;
  final Color tbcShadowColour;
  final Color completeFailTextColour;
  final Color completeFailBackgroundColour;
  final Color completeFailShadowColour;
  final Color tradeHistoryTextColour;
  final Color tradeHistoryBackgroundColour;
  final Color tradeHistoryShadowColour;

  @override
  ThemeExtension<BartTradeWidgetStyle> copyWith({
    Color? incomingTextColour,
    Color? incomingBackgroundColour,
    Color? incomingShadowColour,
    Color? outgoingTextColour,
    Color? outgoingBackgroundColour,
    Color? outgoingShadowColour,
    Color? tbcTextColour,
    Color? tbcBackgroundColour,
    Color? tbcShadowColour,
    Color? completeFailTextColour,
    Color? completeFailBackgroundColour,
    Color? completeFailShadowColour,
    Color? tradeHistoryTextColour,
    Color? tradeHistoryBackgroundColour,
    Color? tradeHistoryShadowColour,
  }) {
    return BartTradeWidgetStyle(
      incomingTextColour: incomingTextColour ?? this.incomingTextColour,
      incomingBackgroundColour:
          incomingBackgroundColour ?? this.incomingBackgroundColour,
      incomingShadowColour: incomingShadowColour ?? this.incomingShadowColour,
      outgoingTextColour: outgoingTextColour ?? this.outgoingTextColour,
      outgoingBackgroundColour:
          outgoingBackgroundColour ?? this.outgoingBackgroundColour,
      outgoingShadowColour: outgoingShadowColour ?? this.outgoingShadowColour,
      tbcTextColour:
          tbcTextColour ?? this.tbcTextColour,
      tbcBackgroundColour: tbcBackgroundColour ??
          this.tbcBackgroundColour,
      tbcShadowColour:
          tbcShadowColour ?? this.tbcShadowColour,
      completeFailTextColour:
          completeFailTextColour ?? this.completeFailTextColour,
      completeFailBackgroundColour:
          completeFailBackgroundColour ?? this.completeFailBackgroundColour,
      completeFailShadowColour:
          completeFailShadowColour ?? this.completeFailShadowColour,
      tradeHistoryTextColour:
          tradeHistoryTextColour ?? this.tradeHistoryTextColour,
      tradeHistoryBackgroundColour:
          tradeHistoryBackgroundColour ?? this.tradeHistoryBackgroundColour,
      tradeHistoryShadowColour:
          tradeHistoryShadowColour ?? this.tradeHistoryShadowColour,
    );
  }

  @override
  ThemeExtension<BartTradeWidgetStyle> lerp(
    covariant ThemeExtension<BartTradeWidgetStyle>? other,
    double t,
  ) {
    if (other == null) {
      return this;
    }

    if (other is BartTradeWidgetStyle) {
      return BartTradeWidgetStyle(
        incomingTextColour:
            Color.lerp(incomingTextColour, other.incomingTextColour, t)!,
        incomingBackgroundColour: Color.lerp(
            incomingBackgroundColour, other.incomingBackgroundColour, t)!,
        incomingShadowColour:
            Color.lerp(incomingShadowColour, other.incomingShadowColour, t)!,
        outgoingTextColour:
            Color.lerp(outgoingTextColour, other.outgoingTextColour, t)!,
        outgoingBackgroundColour: Color.lerp(
            outgoingBackgroundColour, other.outgoingBackgroundColour, t)!,
        outgoingShadowColour:
            Color.lerp(outgoingShadowColour, other.outgoingShadowColour, t)!,
        tbcTextColour: Color.lerp(
            tbcTextColour, other.tbcTextColour, t)!,
        tbcBackgroundColour: Color.lerp(
            tbcBackgroundColour,
            other.tbcBackgroundColour,
            t)!,
        tbcShadowColour: Color.lerp(
            tbcShadowColour, other.tbcShadowColour, t)!,
        completeFailTextColour: Color.lerp(
            completeFailTextColour, other.completeFailTextColour, t)!,
        completeFailBackgroundColour: Color.lerp(completeFailBackgroundColour,
            other.completeFailBackgroundColour, t)!,
        completeFailShadowColour: Color.lerp(
            completeFailShadowColour, other.completeFailShadowColour, t)!,
        tradeHistoryTextColour: Color.lerp(
            tradeHistoryTextColour, other.tradeHistoryTextColour, t)!,
        tradeHistoryBackgroundColour: Color.lerp(tradeHistoryBackgroundColour,
            other.tradeHistoryBackgroundColour, t)!,
        tradeHistoryShadowColour: Color.lerp(
            tradeHistoryShadowColour, other.tradeHistoryShadowColour, t)!,
      );
    }
    return this;
  }
}
