import 'package:flutter/material.dart';

extension BartScrollController on ScrollController {
  void scrollDown({double offset = 0.0}) {
    if (hasClients) {
      animateTo(
        position.maxScrollExtent + offset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    }
  }
}