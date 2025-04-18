import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bart_app/styles/bart_brand_colour_style.dart';
import 'package:bart_app/common/providers/state_provider.dart';
import 'package:bart_app/common/widgets/overlays/login_loading_overlay.dart';

class WelcomeUserPageView extends StatelessWidget {
  const WelcomeUserPageView({
    super.key,
    required this.onSubmit,
    required this.loadOverlay,
  });

  final VoidCallback onSubmit;
  final LoadingBlockFullScreen loadOverlay;

  @override
  Widget build(BuildContext context) {
    final brandTheme = Theme.of(context).extension<BartBrandColours>()!;
    return Consumer<BartStateProvider>(
      builder: (context, provider, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              text: context.tr('onboarding.page.3.1'),
              style: DefaultTextStyle.of(context).style.copyWith(
                    fontSize: 17.spMin,
                  ),
              children: [
                TextSpan(
                  text: provider.userProfile.fullName,
                  style: TextStyle(
                    color: brandTheme.logoColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(text: '!'),
              ],
            ),
          ),
          const SizedBox(height: 15),
          RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              text: context.tr('onboarding.page.3.2'),
              style: DefaultTextStyle.of(context).style.copyWith(
                    fontSize: 17.spMin,
                  ),
              children: [
                TextSpan(
                  text: provider.userProfile.userName,
                  style: TextStyle(
                    color: brandTheme.logoColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: context.tr('onboarding.page.3.3')),
                TextSpan(text: context.tr('onboarding.page.3.4')),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Text(
            context.tr('onboarding.page.3.5'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17.spMin,
            ),
          ),
          const SizedBox(height: 50),
          Center(
            child: OutlinedButton(
              onPressed: () async {
                loadOverlay.show();
                provider.userProfile.isFirstLogin = false;
                provider.updateUserProfile(provider.userProfile).then(
                  (_) {
                    loadOverlay.hide();
                    onSubmit();
                  },
                );
              },
              child: Text(
                context.tr('onboarding.page.finish.btn'),
              ),
            ).animate().shake(
                  delay: 4500.ms,
                  duration: 1800.ms,
                  hz: 2.5,
                  curve: Curves.easeInOut,
                ),
          ),
        ],
      ),
    );
  }
}
