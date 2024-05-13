// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class AppleActionButton extends StatelessWidget {
  AppleActionButton({
    super.key,
    this.onPressed,
    required this.title,
    this.titleColor,
  });

  VoidCallback? onPressed;
  final String title;
  Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: Theme.of(context).elevatedButtonTheme.style,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title),
          const SizedBox(width: 10),
          Image.asset(
            "assets/icons/logo_apple_100x100.png",
            height: 30,
            width: 30,
            color: titleColor,
          )
        ],
      ),
    );
  }
}
