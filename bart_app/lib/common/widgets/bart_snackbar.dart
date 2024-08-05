import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BartSnackBar {
  const BartSnackBar({
    required this.message,
    required this.backgroundColor,
    required this.icon,
    this.actionText,
    this.onPressed,
    this.appearOnTop = false,
  });

  final String message;
  final Color backgroundColor;
  final IconData icon;
  final String? actionText;
  final VoidCallback? onPressed;
  final bool appearOnTop;

  SnackBar build(BuildContext context) {
    return SnackBar(
      dismissDirection: DismissDirection.vertical,
      behavior:
          appearOnTop ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
      margin: appearOnTop
          ? EdgeInsets.only(
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).size.height - 210,
            )
          : null,
      duration: const Duration(seconds: 3),
      content: Row(
        children: <Widget>[
          Icon(
            icon,
            color: backgroundColor.computeLuminance() > 0.5
                ? Colors.black
                : Colors.white,
          ),
          const SizedBox(width: 10),
          FittedBox(
            fit: BoxFit.contain,
            clipBehavior: Clip.antiAlias,
            child: Text(
              message,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              maxLines: 2,
              textScaler: const TextScaler.linear(0.9),
              style: TextStyle(
                fontSize: 18.spMin,
                color: backgroundColor.computeLuminance() > 0.5
                    ? Colors.black
                    : Colors.white,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      // padding: const EdgeInsets.only(left: 10),

      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 10,
      ),
      action: SnackBarAction(
        label: actionText ?? "OK",
        textColor: backgroundColor.computeLuminance() > 0.5
            ? Colors.black
            : Colors.white,
        onPressed: onPressed ?? () {},
      ),
    );
  }
}
