import 'package:flutter/material.dart';

/// declares the keys for the tutorial coach marks independent of the widget
/// so that the keys can be accessed from anywhere in the app and the tutorial
/// can be initialised separately & initiated from anywhere in the app.
class BartTuteWidgetKeys {
  static final GlobalKey bottomNavBarHome = GlobalKey();
  static final GlobalKey bottomNavBarChats = GlobalKey();
  static final GlobalKey bottomNavBarMarket = GlobalKey();
  static final GlobalKey bottomNavBarProfile = GlobalKey();

  static final GlobalKey homePageIncomingTrades = GlobalKey();
  static final GlobalKey homePageOutgoingTrades = GlobalKey();
  static final GlobalKey homePageTBCTrades = GlobalKey();
  static final GlobalKey homePageSTH = GlobalKey();

  static final GlobalKey marketPageTab1 = GlobalKey();
  static final GlobalKey marketPageTab2 = GlobalKey();

  static final GlobalKey appBarHamburgerMenu = GlobalKey();
  static final GlobalKey sideNavMenuSettings = GlobalKey();

  // static final GlobalKey settingsPagePersonalisation = GlobalKey();
}
