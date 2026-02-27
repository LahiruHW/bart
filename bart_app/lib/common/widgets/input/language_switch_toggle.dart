import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bart_app/common/providers/state_provider.dart';
import 'package:bart_app/styles/colour_switch_toggle_style.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';

class BartLocaleToggle extends StatefulWidget {
  const BartLocaleToggle({
    super.key,
  });

  @override
  State<BartLocaleToggle> createState() => _BartLocaleToggleState();
}

class _BartLocaleToggleState extends State<BartLocaleToggle> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BartStateProvider>(context, listen: false);
    final switchStyle =
        Theme.of(context).extension<BartThemeModeToggleStyle>()!;
    final enText = Text(
      'EN',
      style: TextStyle(color: switchStyle.iconColor, fontSize: 15.spMin),
    );
    final frText = Text(
      'FR',
      style: TextStyle(color: switchStyle.iconColor, fontSize: 15.spMin),
    );
    return Selector<BartStateProvider, String>(
      selector: (context, provider) => provider.userProfile.localeString!,
      builder: (context, localeString, child) => SizedBox(
        child: AnimatedToggleSwitch<String>.dual(
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 300),
          // current: provider.userProfile.localeString!,
          current: localeString,
          first: 'en',
          second: 'fr',
          spacing: 5,
          height: 40,
          fittingMode: FittingMode.preventHorizontalOverlapping,
          iconBuilder: (String value) => value == 'en' ? enText : frText,
          textBuilder: (String value) => value == 'en' ? frText : enText,
          styleBuilder: (val) => ToggleStyle(
            backgroundColor: switchStyle.backgroundColor,
            borderColor: Colors.transparent,
            indicatorColor: switchStyle.indicatorColor,
          ),
          onTap: (prop) {
            if (prop.tapped != null) {
              setState(
                () => provider.switchLocale(prop.tapped!.value, context),
              );
            }
          },
          onChanged: (value) {
            setState(() => provider.switchLocale(value, context));
          },
        ),
      ),
    );
  }
}
