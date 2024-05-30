import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bart_app/common/providers/state_provider.dart';
import 'package:bart_app/styles/colour_switch_toggle_style.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';

class BartThemeModeToggle extends StatefulWidget {
  const BartThemeModeToggle({
    super.key,
    this.isDarkMode = true,
  });

  final bool isDarkMode;

  @override
  State<BartThemeModeToggle> createState() => _BartThemeModeToggleState();
}

class _BartThemeModeToggleState extends State<BartThemeModeToggle> {
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BartStateProvider>(context, listen: false);
    final switchStyle =
        Theme.of(context).extension<BartThemeModeToggleStyle>()!;

    return SizedBox(
      child: AnimatedToggleSwitch<bool>.dual(
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        current: provider.userProfile.settings!.isDarkMode,
        first: true,
        second: false,
        spacing: 5,
        height: 40,
        fittingMode: FittingMode.preventHorizontalOverlapping,
        iconBuilder: (bool value) => Icon(
          value ? Icons.nightlight_round : Icons.wb_sunny_rounded,
          size: 20,
          color: switchStyle.iconColor,
        ),
        textBuilder: (bool value) => Icon(
          value ? Icons.wb_sunny_rounded : Icons.nightlight_round,
          size: 20,
          color: switchStyle.iconColor,
        ),
        styleBuilder: (val) => ToggleStyle(
          backgroundColor: switchStyle.backgroundColor,
          borderColor: Colors.transparent,
          // indicatorColor: Theme.of(context).colorScheme.primary.withBlue(90),
          indicatorColor: switchStyle.indicatorColor,
        ),
        onTap: (prop) => setState(() {
          if (prop.tapped != null) {
            provider.updateSettings(isDarkMode: prop.tapped!.value);
          }
        }),
        onChanged: (val) => setState(
          () => provider.updateSettings(isDarkMode: val),
        ),
      ),
    );
  }
}
