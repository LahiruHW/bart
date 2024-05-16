import 'package:bart_app/styles/market_tab_button_style.dart';
import 'package:flutter/material.dart';

class MarketPageTabButton extends StatelessWidget {
  const MarketPageTabButton({
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
    final tabStyle = Theme.of(context).extension<BartMarketTabButtonStyle>()!;

    return FilledButton(
      style: ButtonStyle(
        animationDuration: const Duration(milliseconds: 0),
        enableFeedback: true,
        elevation: WidgetStateProperty.resolveWith(tabStyle.getElevation),
        backgroundColor:
            WidgetStateColor.resolveWith(tabStyle.getForegroundColor),
        textStyle: Theme.of(context).filledButtonTheme.style!.textStyle,
        foregroundColor:
            WidgetStateColor.resolveWith(tabStyle.getBackgroundColor),
      ),
      onPressed: !enabled ? onTap : null,
      child: Text(
        title,
        textAlign: TextAlign.center,
      ),
    );
  }
}
