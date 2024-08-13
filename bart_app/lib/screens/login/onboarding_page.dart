import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bart_app/screens/shared/base.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bart_app/screens/login/onboard_welcome.dart';
import 'package:bart_app/styles/bart_brand_colour_style.dart';
import 'package:bart_app/screens/login/onboard_enter_full_name.dart';
import 'package:bart_app/screens/login/onboard_enter_user_name.dart';
import 'package:bart_app/common/widgets/input/colour_switch_toggle.dart';
import 'package:bart_app/common/widgets/tutorial/bart_tutorial_coach.dart';
import 'package:bart_app/common/widgets/input/language_switch_toggle.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({
    super.key,
  });

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late final PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brandTheme = Theme.of(context).extension<BartBrandColours>()!;
    final animDuration = 1500.ms;
    const animCurve = Curves.easeInOutCubic;
    final pages = [
      EnterFullNamePageView(
        onSubmit: () {
          pageController.nextPage(
            duration: animDuration,
            curve: animCurve,
          );
        },
      ),
      EnterUserNamePageView(
        onSubmit: () {
          pageController.nextPage(
            duration: animDuration,
            curve: animCurve,
          );
        },
      ),
      WelcomeUserPageView(
        onSubmit: () {
          context.go('/login');
          Future.delayed(
            const Duration(milliseconds: 500),
            () => BartTutorialCoach.showTutorial(
              Base.globalKey.currentContext!,
            ),
          );
        },
      ),
    ];

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerTheme: const DividerThemeData(
            color: Colors.transparent,
          ),
        ),
        child: Scaffold(
          backgroundColor: brandTheme.logoBackgroundColor,
          persistentFooterAlignment: AlignmentDirectional.bottomCenter,
          resizeToAvoidBottomInset: false,
          persistentFooterButtons: [
            SizedBox(
              height: 50.spMin,
              child: Text(
                "bart.",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 30.spMin,
                      color: brandTheme.logoColor,
                    ),
              ),
            ),
          ],
          body: Container(
            margin: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
              top: 140.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.tr('onboarding.header'),
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: brandTheme.logoColor,
                        fontSize: 50.spMin,
                        fontWeight: FontWeight.normal,
                      ),
                ),
                SizedBox(height: 8.h),
                Text(
                  context.tr('onboarding.subheader'),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 20.spMin,
                        fontWeight: FontWeight.normal,
                      ),
                ),
                SizedBox(height: 35.h),
                Expanded(
                  flex: 1,
                  child: PageView.builder(
                    controller: pageController,
                    // physics: const NeverScrollableScrollPhysics(),
                    itemCount: pages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(right: 15.w),
                        child: pages[index],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),
                const UnconstrainedBox(
                  alignment: Alignment.bottomCenter,
                  constrainedAxis: Axis.horizontal,
                  child: Center(child: BartThemeModeToggle()),
                ),
                const SizedBox(height: 10),
                const UnconstrainedBox(
                  alignment: Alignment.bottomCenter,
                  constrainedAxis: Axis.horizontal,
                  child: Center(child: BartLocaleToggle()),
                ),
                const SizedBox(height: 30),
              ]
                  .animate(
                    delay: 800.ms,
                    interval: 50.ms,
                  )
                  .fadeIn(
                    duration: 1000.ms,
                    curve: Curves.easeInOut,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
