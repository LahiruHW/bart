import 'package:flutter/material.dart';
import 'package:bart_app/styles/bart_themes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bart_app/styles/bart_material_button_style.dart';
import 'package:bart_app/common/constants/enum_material_button_types.dart';

class BartMaterialButton extends StatefulWidget {
  const BartMaterialButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.buttonType = BartMaterialButtonType.normal,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final BartMaterialButtonType? buttonType;

  BartMaterialButtonStyle getTheme(BuildContext context) {
    final buttonStyle = Theme.of(context).extension<BartMaterialButtonStyle>()!;
    final buttonStyleGreen = Theme.of(context)
        .extension<BartMaterialButtonStyleGreen>()!
        .buttonStyle!;
    switch (buttonType) {
      case BartMaterialButtonType.normal:
        return buttonStyle;
      case BartMaterialButtonType.green:
        return buttonStyleGreen;
      default:
        return buttonStyle;
    }
  }

  @override
  State<StatefulWidget> createState() => _BartMaterialButtonState();
}

class _BartMaterialButtonState extends State<BartMaterialButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    // final buttonStyle = Theme.of(context).extension<BartMaterialButtonStyle>()!;
    final buttonStyle = widget.getTheme(context);

    return GestureDetector(
      // onTapDown: (details) => setState(() => _pressed = true),
      // onTapCancel: () => setState(() => _pressed = false),
      // onTapUp: (details) => setState(() => _pressed = false),
      onLongPressDown: (details) => setState(() => _pressed = true), // 1
      onLongPressStart: (details) => setState(() => _pressed = true), // 2
      onLongPressEnd: (details) => setState(() => _pressed = false), // 3
      onLongPressUp: () => setState(() => _pressed = false), // 4
      onLongPressCancel: () => setState(() => _pressed = false), // ?
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        decoration: BoxDecoration(
          color: buttonStyle.backgroundColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            _pressed
                ? BoxShadow(
                    color: buttonStyle.elevatedShadowColor,
                    blurRadius: 0,
                    spreadRadius: 0,
                    offset: const Offset(0, 0),
                  )
                : BoxShadow(
                    color: buttonStyle.elevatedShadowColor,
                    blurRadius: 3,
                    spreadRadius: 0,
                    offset: const Offset(0, 4.0),
                  ),
          ],
        ),
        child: MaterialButton(
          textColor: buttonStyle.textColor,
          onPressed: widget.onPressed,
          color: buttonStyle.backgroundColor,
          // splashColor: buttonStyle.splashColor,
          // highlightColor: buttonStyle.splashColor,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          minWidth: 150.w,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  child: Text(
                    widget.label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: BartTextTheme.labelStyle.copyWith(
                      fontSize: 19.spMin,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (widget.icon != null) SizedBox(width: 8.spMin),
                if (widget.icon != null)
                  Icon(
                    widget.icon,
                    color: buttonStyle.textColor,
                    size: 20.spMin,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
