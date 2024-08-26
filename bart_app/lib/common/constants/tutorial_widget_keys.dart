import 'package:flutter/material.dart';

/// declares the keys for the tutorial coach marks independent of the widget
/// so that the keys can be accessed from anywhere in the app and the tutorial
/// can be initialised separately & initiated from anywhere in the app.
class BartTuteWidgetKeys {
  static final GlobalKey bottomNavBarHome = GlobalKey();
  static final GlobalKey bottomNavBarChats = GlobalKey();
  static final GlobalKey bottomNavBarMarket = GlobalKey();
  static final GlobalKey bottomNavBarProfile = GlobalKey();

  static final GlobalKey homePageV1IncomingTrades = GlobalKey();
  static final GlobalKey homePageV1OutgoingTrades = GlobalKey();
  static final GlobalKey homePageV1TBCTrades = GlobalKey();
  static final GlobalKey homePageV1STH = GlobalKey();
  static final GlobalKey homePageV2IncomingTrades = GlobalKey();
  static final GlobalKey homePageV2OutgoingTrades = GlobalKey();
  static final GlobalKey homePageV2TBCTrades = GlobalKey();
  static final GlobalKey homePageV2STH = GlobalKey();

  static final GlobalKey marketPageTab1 = GlobalKey();
  static final GlobalKey marketPageTab2 = GlobalKey();
  static final GlobalKey marketPageListedItem = GlobalKey();

  static final GlobalKey appBarHamburgerMenu = GlobalKey();
  static final GlobalKey sideNavMenuSettings = GlobalKey();

  // static final GlobalKey settingsPagePersonalisation = GlobalKey();
}
