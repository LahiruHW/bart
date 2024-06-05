import 'package:flutter/material.dart';

class LoadingBlockFullScreen {
  LoadingBlockFullScreen({
    required this.context,
    this.dismissable = true,
  });

  final BuildContext context;
  final bool dismissable;
  bool isShowing = false;

  void show() {
    isShowing = true;
    showDialog(
      context: context,
      barrierDismissible: dismissable,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
        ),
      ),
    );
  }

  void hide() {
    isShowing = false;
    Navigator.of(context, rootNavigator: true).pop();
  }
}
