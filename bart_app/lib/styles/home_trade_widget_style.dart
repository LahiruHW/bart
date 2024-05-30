import 'package:flutter/material.dart';

class BartTradeWidgetStyle extends ThemeExtension<BartTradeWidgetStyle> {
  BartTradeWidgetStyle({
    required this.incomingTextColour,
    required this.incomingBackgroundColour,
    required this.incomingShadowColour,
    required this.outgoingTextColour,
    required this.outgoingBackgroundColour,
    required this.outgoingShadowColour,
    required this.completeSuccessTextColour,
    required this.completeSuccessBackgroundColour,
    required this.completeSuccessShadowColour,
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
  final Color completeSuccessTextColour;
  final Color completeSuccessBackgroundColour;
  final Color completeSuccessShadowColour;
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
    Color? completeSuccessTextColour,
    Color? completeSuccessBackgroundColour,
    Color? completeSuccessShadowColour,
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
      completeSuccessTextColour:
          completeSuccessTextColour ?? this.completeSuccessTextColour,
      completeSuccessBackgroundColour: completeSuccessBackgroundColour ??
          this.completeSuccessBackgroundColour,
      completeSuccessShadowColour:
          completeSuccessShadowColour ?? this.completeSuccessShadowColour,
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
        completeSuccessTextColour: Color.lerp(
            completeSuccessTextColour, other.completeSuccessTextColour, t)!,
        completeSuccessBackgroundColour: Color.lerp(
            completeSuccessBackgroundColour,
            other.completeSuccessBackgroundColour,
            t)!,
        completeSuccessShadowColour: Color.lerp(
            completeSuccessShadowColour, other.completeSuccessShadowColour, t)!,
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
