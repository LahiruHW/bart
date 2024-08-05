import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bart_app/screens/shared/base.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:bart_app/screens/settings/settings_page.dart';
// import 'package:bart_app/styles/bart_tutorial_content_style.dart';
import 'package:bart_app/common/constants/tutorial_widget_keys.dart';
import 'package:bart_app/common/utility/bart_firebase_analytics.dart';
import 'package:bart_app/common/widgets/tutorial/bart_target_content.dart';
// import 'package:bart_app/common/widgets/tutorial/chat_list_tile_example.dart';
import 'package:bart_app/common/widgets/tutorial/home_trade_widget_example.dart';

class BartTutorialCoach {
  BartTutorialCoach._();

  static late TutorialCoachMark tuteCoach1;
  static late TutorialCoachMark tuteCoach2;
  static late BuildContext _context;
  static late Size _screenSize;
  // static late BartTutorialContentStyle _tuteStyle;

  static const animationDurationMS = 380;

  static void _handleTouches(TargetFocus target) {
    switch (target.identify) {
      case 'bottomNavBarChat':
        target.keyTarget!.currentContext!.go('/chat');
      case 'bottomNavBarMarket':
        target.keyTarget!.currentContext!.go('/market/listed-items');
      case 'bottomNavBarProfile':
        target.keyTarget!.currentContext!.go('/profile');
      case 'appBarHamburgerMenu':
        Base.globalKey.currentState!.openEndDrawer();
      case 'sideNavMenuSettings':
        Base.globalKey.currentContext!.go(
          '/settings',
          extra: {'beginAllExpanded': true},
        );
      case 'settingsPage':
        SettingsPage.globalKey.currentContext!.go('/home');
      default:
        break;
    }
  }

  static void createTutorial(BuildContext thisContext) {
    _context = thisContext;
    _screenSize = MediaQuery.of(_context).size;
    tuteCoach1 = TutorialCoachMark(
      targets: _createTargets(),
      focusAnimationDuration: const Duration(
        milliseconds: animationDurationMS,
      ),
      unFocusAnimationDuration: const Duration(
        milliseconds: animationDurationMS,
      ),
      hideSkip: true,
      colorShadow: Colors.blue.withOpacity(0.1),
      opacityShadow: 0.35,
      // pulseEnable: false,
      onClickTarget: _handleTouches,
      onClickOverlay: _handleTouches,
      showSkipInLastTarget: false,
    );
  }

  static void _previous(TutorialCoachMarkController controller) {
    controller.previous();
  }

  static void _next(TutorialCoachMarkController controller) {
    controller.next();
  }

  static void _skip(TutorialCoachMarkController controller) {
    BartAnalyticsEngine.userEndsTutorial();
    controller.skip();
    try {
      Base.globalKey.currentContext!.go('/home');
    } catch (e) {
      SettingsPage.globalKey.currentContext!.go('/home');
    }
  }

  static void _finish(TutorialCoachMarkController controller) {
    BartAnalyticsEngine.userEndsTutorial();
    tuteCoach1.finish();
    try {
      Base.globalKey.currentContext!.go('/home');
    } catch (e) {
      SettingsPage.globalKey.currentContext!.go('/home');
    }
  }

  static List<TargetFocus> _createTargets() {
    List<TargetFocus> tute1Targets = [];
    //////////////////////////////////////////////////////////////
    ///////////////////////// HOME PAGE //////////////////////////
    tute1Targets.add(
      TargetFocus(
        identify: "homePageIncomingTrades",
        keyTarget: BartTuteWidgetKeys.homePageIncomingTrades,
        shape: ShapeLightFocus.RRect,
        radius: 10,
        paddingFocus: 10,
        enableOverlayTab: true,
        enableTargetTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            padding: EdgeInsets.zero,
            builder: (context, controller) {
              return BartTargetContent(
                skipText: tr('skip'),
                nextText: tr('next'),
                showPreviousBtn: false,
                text: tr('tute.homepage.incoming'),
                extraContent: Builder(builder: (context) {
                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      HomeWidgetsExample.buildIncomingTrade(),
                    ],
                  );
                }),
                onSkip: () => _skip(controller),
                onNext: () => _next(controller),
              );
            },
          )
        ],
      ),
    );
    tute1Targets.add(
      TargetFocus(
        identify: "homePageOutgoingTrades",
        keyTarget: BartTuteWidgetKeys.homePageOutgoingTrades,
        shape: ShapeLightFocus.RRect,
        radius: 10,
        paddingFocus: 10,
        enableOverlayTab: true,
        enableTargetTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            padding: EdgeInsets.zero,
            builder: (context, controller) {
              return BartTargetContent(
                skipText: tr('skip'),
                previousText: tr('back'),
                nextText: tr('next'),
                text: tr('tute.homepage.outgoing'),
                extraContent: Column(
                  children: [
                    const SizedBox(height: 10),
                    HomeWidgetsExample.buildOutgoingTrade(),
                  ],
                ),
                onSkip: () => _skip(controller),
                onPrevious: () => _previous(controller),
                onNext: () => _next(controller),
              );
            },
          )
        ],
      ),
    );
    tute1Targets.add(
      TargetFocus(
        identify: "homePageTBCTrades",
        keyTarget: BartTuteWidgetKeys.homePageTBCTrades,
        shape: ShapeLightFocus.RRect,
        radius: 10,
        paddingFocus: 10,
        enableOverlayTab: true,
        enableTargetTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            padding: EdgeInsets.zero,
            builder: (context, controller) {
              return BartTargetContent(
                skipText: tr('skip'),
                previousText: tr('back'),
                nextText: tr('next'),
                text: tr('tute.homepage.tbc.1'),
                extraContent: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      tr('tute.homepage.tbc.2'),
                      style: TextStyle(fontSize: 16.spMin),
                    ),
                    const SizedBox(height: 8),
                    HomeWidgetsExample.buildTBCTrade1(),
                    const SizedBox(height: 8),
                    Text(
                      tr(
                        'or',
                      ),
                      style: TextStyle(
                        fontSize: 16.spMin,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      tr('tute.homepage.tbc.3'),
                      style: TextStyle(fontSize: 16.spMin),
                    ),
                    const SizedBox(height: 8),
                    HomeWidgetsExample.buildTBCTrade2(),
                    const SizedBox(height: 8),
                    Text(
                      tr('tute.homepage.tbc.4'),
                      style: TextStyle(fontSize: 16.spMin),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      tr('tute.homepage.tbc.5'),
                      style: TextStyle(fontSize: 16.spMin),
                    ),
                  ],
                ),
                onSkip: () => _skip(controller),
                onPrevious: () => _previous(controller),
                onNext: () => _next(controller),
              );
            },
          )
        ],
      ),
    );
    tute1Targets.add(
      TargetFocus(
        identify: "homePageSTH",
        keyTarget: BartTuteWidgetKeys.homePageSTH,
        shape: ShapeLightFocus.RRect,
        radius: 10,
        paddingFocus: 10,
        enableOverlayTab: true,
        enableTargetTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            padding: EdgeInsets.zero,
            builder: (context, controller) {
              return BartTargetContent(
                skipText: tr('skip'),
                previousText: tr('back'),
                nextText: tr('next'),
                text: tr('tute.homepage.sth'),
                extraContent: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    HomeWidgetsExample.buildSTHTrade1(),
                    const SizedBox(height: 8),
                    HomeWidgetsExample.buildSTHTrade2(),
                  ],
                ),
                onSkip: () => _skip(controller),
                onPrevious: () => _previous(controller),
                onNext: () => _next(controller),
              );
            },
          )
        ],
      ),
    );
    //////////////////////////////////////////////////////////////
    ///////////////////////// CHAT PAGE //////////////////////////
    tute1Targets.add(
      TargetFocus(
        identify: "bottomNavBarChat",
        keyTarget: BartTuteWidgetKeys.bottomNavBarChats,
        shape: ShapeLightFocus.Circle,
        radius: 10,
        paddingFocus: 10,
        enableOverlayTab: true,
        enableTargetTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            padding: EdgeInsets.zero,
            builder: (context, controller) {
              return BartTargetContent(
                skipText: tr('skip'),
                previousText: tr('back'),
                nextText: tr('next'),
                text: tr('tute.chatPage.1'),
                onSkip: () => _skip(controller),
                onPrevious: () {
                  Base.globalKey.currentContext!.go('/home');
                  _previous(controller);
                },
                onNext: () {
                  Base.globalKey.currentContext!.go('/chat');
                  _next(controller);
                },
              );
            },
          )
        ],
      ),
    );
    tute1Targets.add(
      TargetFocus(
        identify: "chatPageChatList",
        targetPosition: TargetPosition(
          const Size(2, 2),
          Offset((_screenSize.width / 2) - 1, _screenSize.height * 0.75),
        ),
        radius: 10,
        paddingFocus: 10,
        enableOverlayTab: true,
        enableTargetTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            padding: EdgeInsets.zero,
            builder: (context, controller) {
              return BartTargetContent(
                skipText: tr('skip'),
                previousText: tr('back'),
                nextText: tr('next'),
                text: tr('tute.chatPage.2'),
                // extraContent: Column(
                //   children: [
                //     const SizedBox(height: 10),
                //     Container(
                //       decoration: BoxDecoration(
                //         border: Border.all(
                //           width: 0.2,
                //           color: Colors.grey,
                //         ),
                //       ),
                //       child: ChatWidgetsExample.chatListTileExample(),
                //     ),
                //     const SizedBox(height: 10),
                //   ],
                // ),
                onSkip: () => _skip(controller),
                onPrevious: () {
                  Base.globalKey.currentContext!.go('/home');
                  _previous(controller);
                },
                onNext: () => _next(controller),
              );
            },
          )
        ],
      ),
    );
    //////////////////////////////////////////////////////////////
    //////////////////////// MARKET PAGE /////////////////////////
    tute1Targets.add(
      TargetFocus(
        identify: "bottomNavBarMarket",
        keyTarget: BartTuteWidgetKeys.bottomNavBarMarket,
        radius: 10,
        paddingFocus: 10,
        enableOverlayTab: true,
        enableTargetTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            padding: EdgeInsets.zero,
            builder: (context, controller) {
              return BartTargetContent(
                skipText: tr('skip'),
                previousText: tr('back'),
                nextText: tr('next'),
                text: tr('tute.marketPage.1'),
                onSkip: () => _skip(controller),
                onPrevious: () {
                  Base.globalKey.currentContext!.go('/chat');
                  _previous(controller);
                },
                onNext: () {
                  Base.globalKey.currentContext!.go('/market/listed-items');
                  _next(controller);
                },
              );
            },
          )
        ],
      ),
    );
    tute1Targets.add(
      TargetFocus(
        identify: "marketPageTab1",
        shape: ShapeLightFocus.RRect,
        keyTarget: BartTuteWidgetKeys.marketPageTab1,
        radius: 10,
        paddingFocus: 10,
        enableOverlayTab: true,
        enableTargetTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            padding: EdgeInsets.zero,
            builder: (context, controller) {
              return BartTargetContent(
                skipText: tr('skip'),
                previousText: tr('back'),
                nextText: tr('next'),
                text: tr('tute.marketPage.2.1'),
                extraContent: Column(
                  children: [
                    const SizedBox(height: 10),
                    // Text('You can make all your listed items available for trade here and make return offers to other users.'),
                    Text(
                      tr('tute.marketPage.2.2'),
                      style: TextStyle(fontSize: 16.spMin),
                    ),
                  ],
                ),
                onSkip: () => _skip(controller),
                onPrevious: () {
                  Base.globalKey.currentContext!.go('/chat');
                  _previous(controller);
                },
                onNext: () => _next(controller),
              );
            },
          )
        ],
      ),
    );
    // ADD REQUESTS/SERVICE TAB TUTORIAL HERE
    //////////////////////////////////////////////////////////////
    //////////////////////// PROFILE PAGE ////////////////////////
    tute1Targets.add(
      TargetFocus(
        identify: "bottomNavBarProfile",
        keyTarget: BartTuteWidgetKeys.bottomNavBarProfile,
        shape: ShapeLightFocus.Circle,
        radius: 10,
        paddingFocus: 10,
        enableOverlayTab: true,
        enableTargetTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            padding: EdgeInsets.zero,
            builder: (context, controller) {
              return BartTargetContent(
                skipText: tr('skip'),
                previousText: tr('back'),
                nextText: tr('next'),
                text: tr('tute.profilePage.1'),
                onSkip: () => _skip(controller),
                onPrevious: () => _previous(controller),
                onNext: () {
                  Base.globalKey.currentContext!.go('/profile');
                  _next(controller);
                },
              );
            },
          )
        ],
      ),
    );
    tute1Targets.add(
      TargetFocus(
        identify: "profilePageDetails",
        targetPosition: TargetPosition(
          const Size(2, 2),
          Offset((_screenSize.width / 2) - 1, _screenSize.height * 0.85),
        ),
        radius: 10,
        paddingFocus: 10,
        enableOverlayTab: true,
        enableTargetTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            padding: EdgeInsets.zero,
            builder: (context, controller) {
              return BartTargetContent(
                skipText: tr('skip'),
                previousText: tr('back'),
                nextText: tr('next'),
                text: tr('tute.profilePage.2'),
                onSkip: () => _skip(controller),
                onPrevious: () {
                  Base.globalKey.currentContext!.go('/market/listed-items');
                  _previous(controller);
                },
                onNext: () => _next(controller),
              );
            },
          )
        ],
      ),
    );
    //////////////////////////////////////////////////////////////
    //////////////////////// SETTINGS PAGE ///////////////////////
    tute1Targets.add(
      TargetFocus(
        identify: "appBarHamburgerMenu",
        keyTarget: BartTuteWidgetKeys.appBarHamburgerMenu,
        radius: 10,
        paddingFocus: 10,
        enableOverlayTab: true,
        enableTargetTab: true,
        contents: [
          TargetContent(
            builder: (context, controller) {
              return BartTargetContent(
                skipText: tr('skip'),
                previousText: tr('back'),
                nextText: tr('next'),
                text: tr('tute.settingsPage.1'),
                onSkip: () => _skip(controller),
                onNext: () {
                  Base.globalKey.currentState!.openEndDrawer();
                  Future.delayed(
                    const Duration(milliseconds: 200),
                    () => _next(controller),
                  );
                },
                onPrevious: () => _previous(controller),
              );
            },
          )
        ],
      ),
    );
    tute1Targets.add(
      TargetFocus(
        identify: "sideNavMenuSettings",
        keyTarget: BartTuteWidgetKeys.sideNavMenuSettings,
        shape: ShapeLightFocus.RRect,
        radius: 10,
        paddingFocus: 10,
        enableOverlayTab: true,
        enableTargetTab: true,
        contents: [
          TargetContent(
            builder: (context, controller) {
              return BartTargetContent(
                skipText: tr('skip'),
                previousText: tr('back'),
                nextText: tr('next'),
                text: tr('tute.settingsPage.2'),
                onSkip: () => _skip(controller),
                onNext: () {
                  Base.globalKey.currentContext!.go(
                    '/settings',
                    extra: {'beginAllExpanded': true},
                  );
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => _next(controller),
                  );
                },
                onPrevious: () {
                  Base.globalKey.currentState!.closeEndDrawer();
                  _previous(controller);
                },
              );
            },
          )
        ],
      ),
    );
    tute1Targets.add(
      TargetFocus(
        identify: "settingsPage",
        // keyTarget: BartTuteWidgetKeys.settingsPagePersonalisation,
        targetPosition: TargetPosition(
          const Size(2, 2),
          Offset((_screenSize.width / 2) - 1, _screenSize.height * 0.75),
        ),
        radius: 10,
        paddingFocus: 10,
        // shape: ShapeLightFocus.RRect,
        enableOverlayTab: true,
        enableTargetTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            padding: EdgeInsets.zero,
            builder: (context, controller) {
              return BartTargetContent(
                showPreviousBtn: true,
                showNextBtn: false,
                previousText: tr('back'),
                skipText: tr('finish'),
                text: tr('tute.settingsPage.3'),
                onSkip: () => _finish(controller),
                onPrevious: () {
                  SettingsPage.globalKey.currentContext!.go('/profile');
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) {
                      Base.globalKey.currentState!.openEndDrawer();
                      _previous(controller);
                    },
                  );
                },
              );
            },
          )
        ],
      ),
    );
    //////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////
    return tute1Targets;
  }

  static void showTutorial(BuildContext thisContext) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      tuteCoach1.show(
        context: thisContext,
        rootOverlay: true,
      );
    });
  }
}
