import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bart_app/common/widgets/bart_snackbar.dart';
import 'package:bart_app/styles/bart_brand_colour_style.dart';
import 'package:bart_app/common/providers/state_provider.dart';
import 'package:bart_app/common/widgets/buttons/apple_action_button.dart';
import 'package:bart_app/common/widgets/input/colour_switch_toggle.dart';
import 'package:bart_app/common/widgets/input/language_switch_toggle.dart';
import 'package:bart_app/common/widgets/buttons/google_action_button.dart';
import 'package:bart_app/common/widgets/overlays/login_loading_overlay.dart';

/// Provides options to either signup/login with a Google or LegalEase User Account
class LoginTypeSelectPage extends StatefulWidget {
  const LoginTypeSelectPage({
    super.key,
  });

  static final GlobalKey<ScaffoldState> globalKey = GlobalKey();

  @override
  State<LoginTypeSelectPage> createState() => _LoginTypeSelectPageState();
}

class _LoginTypeSelectPageState extends State<LoginTypeSelectPage> {
  User? user;

  @override
  Widget build(BuildContext context) {
    final brandTheme = Theme.of(context).extension<BartBrandColours>()!;
    final loadingOverlay =
        LoadingBlockFullScreen(context: context, dismissable: false);
    final stateProvider =
        Provider.of<BartStateProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: brandTheme.logoBackgroundColor,
      key: LoginTypeSelectPage.globalKey,
      body: Center(
        child: SizedBox(
          height: 450.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "bart.",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 90.spMin,
                      color: brandTheme.logoColor,
                    ),
              ),
              const SizedBox(height: 15),

              GoogleActionButton(
                onPressed: () {
                  loadingOverlay.show();

                  stateProvider.signInWithGoogle().then(
                    (value) {
                      debugPrint('|||||||||||||||||||||||||||||||||||||||||| $value');
                      if (!value) {
                        loadingOverlay.hide();
                      } else {
                        Future.delayed(
                          const Duration(milliseconds: 1500),
                          () {
                            loadingOverlay.hide();
                            stateProvider.userProfile.isFirstLogin
                                ? context.go("/onboard")
                                : context.go("/home-trades");
                          },
                        );
                      }
                    },
                  );
                }, // update the user state
                title: context.tr('login.with.google'),
                titleColor: brandTheme.loginBtnTextColor,
              ),

              const SizedBox(height: 15),
              AppleActionButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    BartSnackBar(
                      message: context.tr('login.with.apple.id.missing'),
                      backgroundColor: Colors.amber,
                      icon: Icons.info_outline_rounded,
                    ).build(context),
                  );
                },
                // title: "Login with Apple ID",
                title: context.tr('login.with.apple.id'),
                titleColor: brandTheme.loginBtnTextColor,
              ),
              const SizedBox(height: 15),
              // RichText(
              //   textWidthBasis: TextWidthBasis.longestLine,
              //   maxLines: 2,
              //   textAlign: TextAlign.center,
              //   softWrap: false,
              //   text: TextSpan(
              //     children: [
              //       TextSpan(
              //         text: "No user account? ",
              //         style: Theme.of(context).textTheme.labelSmall!.copyWith(
              //               fontSize: 14,
              //             ),
              //       ),
              //       TextSpan(
              //         text: "Click here",
              //         style: Theme.of(context).textTheme.labelSmall!.copyWith(
              //               color: Theme.of(context).colorScheme.primary,
              //               fontSize: 14,
              //             ),
              //         recognizer: TapGestureRecognizer()
              //           ..onTap = () {
              //             debugPrint("===================== Sign-up clicked");
              //             GoRouter.of(context).push("/signup-uac");
              //           },
              //       ),
              //       TextSpan(
              //         text: " to Sign-Up ",
              //         style: Theme.of(context).textTheme.labelSmall!.copyWith(
              //               fontSize: 14,
              //             ),
              //       ),
              //     ],
              //   ),
              // ),
              const BartThemeModeToggle(),
              const SizedBox(height: 15),
              const BartLocaleToggle(),
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
    );
  }
}
