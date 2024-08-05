// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';

class GoogleActionButton extends StatelessWidget {
  GoogleActionButton({
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
            "assets/icons/logo_google_96x96.png",
            height: 30,
            width: 30,
          )
        ],
      ),
    );
  }
}
