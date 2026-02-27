import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bart_app/styles/bart_page_tab_button_style.dart';

class BartPageTabButton extends StatelessWidget {
  const BartPageTabButton({
    required this.title,
    required this.onTap,
    required this.enabled,
    super.key,
  });

  final String title;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tabStyle = Theme.of(context).extension<BartTabButtonStyle>()!;

    return FilledButton(
      style: ButtonStyle(
        animationDuration: const Duration(milliseconds: 0),
        enableFeedback: true,
        elevation: WidgetStateProperty.resolveWith(tabStyle.getElevation),
        backgroundColor:
            WidgetStateColor.resolveWith(tabStyle.getBackgroundColor),
        textStyle: Theme.of(context).filledButtonTheme.style!.textStyle,
        foregroundColor:
            WidgetStateColor.resolveWith(tabStyle.getForegroundColor),
      ),
      onPressed: !enabled ? onTap : null,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14.spMin, fontWeight: FontWeight.w600),
      ),
    );
  }
}
