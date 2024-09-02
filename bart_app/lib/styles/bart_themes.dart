import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bart_app/styles/index.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BartAppTheme {
  BartAppTheme._();

  // light mode colours //////////////////////////////////////////////
  static Color red1 = const Color.fromRGBO(255, 56, 96, 1.0);
  static Color red2 = const Color.fromRGBO(222, 93, 93, 1.0);
  static Color red3 = const Color.fromRGBO(238, 97, 97, 1.0);
  static Color red4 = const Color.fromRGBO(183, 93, 105, 1.0);
  static Color red5 = const Color.fromRGBO(234, 205, 194, 1.0);
  static Color red6 = const Color.fromRGBO(255, 234, 215, 1.0);

  // dark mode colours ///////////////////////////////////////////////
  static Color black1 = const Color.fromRGBO(35, 35, 35, 1.0);
  static Color black2 = const Color.fromRGBO(17, 17, 17, 1.0);
  static Color grey1 = const Color.fromRGBO(37, 37, 37, 1.0);
  static Color purple1 = const Color.fromRGBO(83, 2, 133, 1.0);
  static Color purple2 = const Color.fromRGBO(72, 55, 119, 1.0);
  static Color purple3 = const Color.fromRGBO(157, 81, 255, 1.0);
  static Color purple4 = const Color.fromRGBO(162, 88, 255, 1.0);
  static Color purple5 = const Color.fromRGBO(186, 109, 214, 1.0);

  static Color red7 = const Color.fromRGBO(209, 109, 106, 1.0);

  // other colours ///////////////////////////////////////////////////
  static Color red8 = const Color.fromRGBO(255, 130, 126, 1.0);
  static Color green1 = const Color.fromRGBO(25, 151, 23, 1.0);
  static Color green2 = const Color.fromRGBO(37, 212, 9, 1.0);
  static Color green3 = const Color.fromRGBO(96, 171, 69, 1.0);
  static Color green4 = const Color.fromRGBO(81, 200, 107, 1.0);
  static Color blue1 = const Color.fromRGBO(32, 111, 184, 1.0);
  static Color blue2 = const Color.fromRGBO(0, 178, 255, 1.0);
  static Color blue3 = const Color.fromRGBO(122, 138, 179, 1.0);
  static Color yellow1 = const Color.fromRGBO(209, 235, 52, 1.0);
  static Color orange1 = const Color.fromRGBO(255, 3, 3, 1.0);

  static ColorScheme lightColorScheme = ColorScheme.fromSwatch(
    primarySwatch: Colors.red,
    accentColor: red1,
    backgroundColor: Colors.white,
    cardColor: Colors.white,
    errorColor: Colors.red,
    brightness: Brightness.light,
  );

  static ColorScheme darkColorScheme = ColorScheme.fromSwatch(
    primarySwatch: Colors.red,
    accentColor: red1,
    backgroundColor: black2,
    cardColor: Colors.black,
    errorColor: red5,
    brightness: Brightness.dark,
  );

  static ThemeData lightTheme = ThemeData(
    colorScheme: lightColorScheme,
    scaffoldBackgroundColor: Colors.white,
    dialogBackgroundColor: Colors.white,
    textTheme: BartTextTheme.globalTextTheme,
    useMaterial3: true,
    cardColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: red1,
      shadowColor: Colors.black.withOpacity(0.2),
      titleTextStyle: BartTextTheme.logoStyle.copyWith(
        fontSize: 30,
        color: red1,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 20.0,
      backgroundColor: Colors.white,
      showUnselectedLabels: false,
      selectedItemColor: red1,
      unselectedItemColor: Colors.black,
      type: BottomNavigationBarType.shifting, // looks cool
      selectedLabelStyle: BartTextTheme.globalTextTheme.labelSmall!.copyWith(
        color: red1,
        fontSize: 12.spMin,
      ),
    ),
    expansionTileTheme: const ExpansionTileThemeData(
      backgroundColor: Colors.white,
      collapsedBackgroundColor: Colors.white,
      childrenPadding: EdgeInsets.symmetric(horizontal: 10),
      textColor: Colors.red,
      collapsedTextColor: Colors.black,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStateProperty.all(
          BartTextTheme.globalTextTheme.labelLarge!.copyWith(
            color: Colors.black,
            fontSize: 18.spMin,
          ),
        ),
        backgroundColor: WidgetStateProperty.all(Colors.white),
        foregroundColor: WidgetStateProperty.all(Colors.black),
        surfaceTintColor: WidgetStateProperty.all(grey1),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
        minimumSize: WidgetStateProperty.all(Size(300.w, 60.h)),
        maximumSize: WidgetStateProperty.all(Size(300.w, 60.h)),
        fixedSize: WidgetStateProperty.all(Size(300.w, 60.h)),
      ),
    ),
    listTileTheme: ListTileThemeData(
      tileColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      dense: false,
      enableFeedback: true,
      titleTextStyle: BartTextTheme.globalTextTheme.bodyLarge!.copyWith(
        fontSize: 25.spMin,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      subtitleTextStyle: BartTextTheme.globalTextTheme.bodySmall!.copyWith(
        fontSize: 18.spMin,
        color: Colors.black.withOpacity(0.8),
        fontWeight: FontWeight.normal,
      ),
      leadingAndTrailingTextStyle:
          BartTextTheme.globalTextTheme.bodySmall!.copyWith(
        fontSize: 15.spMin,
        color: Colors.black.withOpacity(0.9),
        fontWeight: FontWeight.normal,
      ),
      minVerticalPadding: 5,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(red1),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        shadowColor: WidgetStatePropertyAll(Colors.black.withOpacity(0.5)),
        surfaceTintColor: WidgetStatePropertyAll(BartAppTheme.red1),
        foregroundColor: const WidgetStatePropertyAll(Colors.white),
        // animationDuration: const Duration(milliseconds: 400),
        fixedSize: const WidgetStatePropertyAll(Size(double.infinity, 50)),
        textStyle: WidgetStatePropertyAll(
          BartTextTheme.globalTextTheme.titleSmall!.copyWith(
            fontSize: 15,
            color: Colors.white,
          ),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.all(8),
      focusColor: red1,
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black.withOpacity(0.2),
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: red1,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      hintStyle: BartTextTheme.globalTextTheme.bodySmall!.copyWith(
        fontSize: 18.spMin,
        color: Colors.black.withOpacity(0.3),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: red1,
      foregroundColor: Colors.white,
      splashColor: Colors.white.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 10,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white,
    ),
    dividerColor: Colors.black38,
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        alignment: Alignment.center,
        fixedSize: WidgetStatePropertyAll(Size(250.w, 45)),
        minimumSize: WidgetStatePropertyAll(Size(250.w, 45)),
        maximumSize: WidgetStatePropertyAll(Size(250.w, 45)),
        foregroundColor: const WidgetStatePropertyAll(Colors.black),
        overlayColor: const WidgetStatePropertyAll(Colors.green),
        backgroundColor: const WidgetStatePropertyAll(Colors.white),
        textStyle: WidgetStatePropertyAll(
          BartTextTheme.globalTextTheme.labelSmall!.copyWith(
            fontSize: 16,
          ),
        ),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        side: const WidgetStatePropertyAll(
          BorderSide(
            width: 0.5,
            color: Colors.transparent,
          ),
        ),
      ),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      selectedIcon: null,
      style: ButtonStyle(
        foregroundColor: const WidgetStatePropertyAll(Colors.black),
        iconSize: WidgetStatePropertyAll(25.spMin),
        visualDensity: const VisualDensity(horizontal: 4, vertical: 4),
        animationDuration: const Duration(milliseconds: 200),
        side: const WidgetStatePropertyAll(
          BorderSide(color: Colors.grey, width: 0.25),
        ),
      ),
    ),
    cupertinoOverrideTheme: const NoDefaultCupertinoThemeData(
      brightness: Brightness.light,
    ),
    extensions: {
      BartBrandColours(
        logoColor: Colors.white,
        logoBackgroundColor: red1,
        loginBtnTextColor: Colors.black,
        loginBtnBackgroundColor: Colors.white,
      ),
      BartChatBubbleStyle(
        senderTextColor: red1,
        senderBackgroundColor: red6,
        receiverTextColor: Colors.white,
        receiverBackgroundColor: red1,
        textStyle: BartTextTheme.globalTextTheme.labelSmall!.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 12.spMin,
        ),
        senderContextBackgroundColor: Colors.white,
        receiverContextBackgroundColor: red6,
        senderContextTextColor: red1,
        receiverContextTextColor: red1,
        unreadTickColour: Colors.grey,
        readTickColour: Colors.blue,
      ),
      BartTradeWidgetStyle(
        incomingTextColour: Colors.white,
        incomingBackgroundColour: red1,
        incomingShadowColour: Colors.black.withOpacity(0.4),
        outgoingTextColour: red1,
        outgoingBackgroundColour: Colors.white,
        outgoingShadowColour: red1.withOpacity(0.8),
        tbcTextColour: purple3,
        tbcBackgroundColour: Colors.white,
        tbcShadowColour: purple3.withOpacity(0.8),
        completeFailTextColour: Colors.black,
        completeFailBackgroundColour: Colors.grey,
        completeFailShadowColour: Colors.black.withOpacity(0.4),
        tradeHistoryTextColour: Colors.black,
        tradeHistoryBackgroundColour: Colors.white,
        tradeHistoryShadowColour: Colors.black,
      ),
      BartMarketListItemStyle(
        splashColor: Colors.grey.withOpacity(0.2),
        titleColor: red1,
        // titleColor: Colors.black,
        cardTheme: CardTheme(
          color: Colors.white,
          surfaceTintColor: Colors.white38,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          clipBehavior: Clip.antiAlias,
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
        ),
      ),
      BartTabButtonStyle(
        enabledElevation: 0,
        enabledBackgroundColor: red1.withOpacity(0.5),
        enabledForegroundColor: Colors.white.withOpacity(0.5),
        disabledElevation: 10,
        disabledBackgroundColor: red1,
        disabledForegroundColor: Colors.white,
      ),
      BartMaterialButtonStyle(
        backgroundColor: red1,
        textColor: Colors.white,
        splashColor: Colors.white.withOpacity(0.3),
        elevatedShadowColor: Colors.black.withOpacity(0.3),
      ),
      BartMaterialButtonStyleGreen(
        buttonStyle: BartMaterialButtonStyle(
          backgroundColor: green2,
          textColor: Colors.white,
          splashColor: Colors.white.withOpacity(0.3),
          elevatedShadowColor: Colors.black.withOpacity(0.3),
        ),
      ),
      BartMaterialButtonDisabledStyle(
        buttonStyle: BartMaterialButtonStyle(
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          splashColor: Colors.transparent,
          elevatedShadowColor: Colors.transparent,
        ),
      ),
      BartShimmerLoadStyle(
        baseColor: Colors.grey,
        highlightColor: Colors.white,
      ),
      BartThemeModeToggleStyle(
        iconColor: Colors.black,
        indicatorColor: red1,
        backgroundColor: Colors.black.withOpacity(0.5),
      ),
      BartProfilePageColourStyle(
        gradientColourTop: purple1,
        gradientColourBottom: red1,
        containerColor: Colors.white,
        profileInfoCardColor: Colors.white,
        textColor: Colors.black,
      ),
      BartPaymentPageStyle(
        currencyDropdownBackgroundColor: Colors.grey.shade300,
        currencyDropdownIconColor: Colors.grey,
        currencyDropdownTextColor: Colors.black,
        textFieldBackgroundColor: Colors.white,
        textFieldTextColor: Colors.black,
      ),
      BartTutorialContentStyle(
        contentTextColour: Colors.black,
        contentBackgroundColour: Colors.white,
        overlayShadowColour: Colors.red,
        buttonTextColor: Colors.red,
      ),
      BartSegmentSliderStyle(
        iconColour: Colors.grey,
        selectedIconColour: Colors.white,
        thumbColor: red1,
        backgroundColor: Colors.grey.withOpacity(0.2),
      ),
      TradeWidgetBadgeStyle(
        badgeColor: red1,
        selectedBadgeColor: Colors.white,
        labelColor: Colors.white,
        selectedLabelColor: red1,
      ),
    },
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: darkColorScheme,
    scaffoldBackgroundColor: black2,
    dialogBackgroundColor: black1,
    textTheme: BartTextTheme.globalTextTheme,
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: red1,
      titleTextStyle: BartTextTheme.logoStyle.copyWith(
        fontSize: 30,
        color: red1,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 20.0,
      backgroundColor: black2,
      showUnselectedLabels: false,
      selectedItemColor: red1,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.shifting, // looks cool
      selectedLabelStyle: BartTextTheme.globalTextTheme.labelSmall!.copyWith(
        color: red1,
        fontSize: 12.spMin,
      ),
    ),
    expansionTileTheme: ExpansionTileThemeData(
      backgroundColor: black2,
      collapsedBackgroundColor: black2,
      childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
      textColor: Colors.red,
      collapsedTextColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(grey1),
        foregroundColor: WidgetStateProperty.all(Colors.white),
        surfaceTintColor: WidgetStateProperty.all(grey1),
        overlayColor: WidgetStateProperty.all(Colors.white.withOpacity(0.1)),
        textStyle: WidgetStateProperty.all(
          BartTextTheme.globalTextTheme.labelLarge!.copyWith(
            color: Colors.white,
            fontSize: 18.spMin,
          ),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
        minimumSize: WidgetStateProperty.all(Size(300.w, 60.h)),
        maximumSize: WidgetStateProperty.all(Size(300.w, 60.h)),
        fixedSize: WidgetStateProperty.all(Size(300.w, 60.h)),
      ),
    ),
    listTileTheme: ListTileThemeData(
      tileColor: black2,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      dense: false,
      enableFeedback: true,
      titleTextStyle: BartTextTheme.globalTextTheme.bodyLarge!.copyWith(
        fontSize: 25.spMin,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      subtitleTextStyle: BartTextTheme.globalTextTheme.bodySmall!.copyWith(
        fontSize: 18,
        color: Colors.white.withOpacity(0.8),
        fontWeight: FontWeight.normal,
      ),
      leadingAndTrailingTextStyle:
          BartTextTheme.globalTextTheme.bodySmall!.copyWith(
        fontSize: 15,
        color: Colors.white.withOpacity(0.9),
        fontWeight: FontWeight.normal,
      ),
      minVerticalPadding: 5,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: const WidgetStatePropertyAll(Colors.black),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        shadowColor: WidgetStatePropertyAll(Colors.white.withOpacity(0.1)),
        surfaceTintColor: const WidgetStatePropertyAll(Colors.black),
        foregroundColor: WidgetStatePropertyAll(red1),
        animationDuration: const Duration(milliseconds: 400),
        fixedSize: const WidgetStatePropertyAll(Size(double.infinity, 50)),
        textStyle: WidgetStatePropertyAll(
          BartTextTheme.globalTextTheme.titleSmall!.copyWith(
            fontSize: 15,
            color: red1,
          ),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.black,
      contentPadding: const EdgeInsets.all(8),
      focusColor: red1,
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white.withOpacity(0.1),
        ),
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: red1,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
      ),
      hintStyle: BartTextTheme.globalTextTheme.bodySmall!.copyWith(
        fontSize: 18.spMin,
        color: Colors.white.withOpacity(0.3),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: red1,
      foregroundColor: Colors.white,
      splashColor: Colors.white.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 10,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: black1,
    ),
    dividerColor: Colors.white38,
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        alignment: Alignment.center,
        fixedSize: WidgetStatePropertyAll(Size(250.w, 45)),
        minimumSize: WidgetStatePropertyAll(Size(250.w, 45)),
        maximumSize: WidgetStatePropertyAll(Size(250.w, 45)),
        foregroundColor: const WidgetStatePropertyAll(Colors.black),
        overlayColor: const WidgetStatePropertyAll(Colors.green),
        backgroundColor: const WidgetStatePropertyAll(Colors.white),
        textStyle: WidgetStatePropertyAll(
          BartTextTheme.globalTextTheme.labelSmall!.copyWith(
            fontSize: 16,
          ),
        ),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        side: const WidgetStatePropertyAll(
          BorderSide(
            width: 0.5,
            color: Colors.transparent,
          ),
        ),
      ),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      selectedIcon: null,
      style: ButtonStyle(
        foregroundColor: const WidgetStatePropertyAll(Colors.white),
        iconSize: WidgetStatePropertyAll(25.spMin),
        visualDensity: const VisualDensity(horizontal: 4, vertical: 4),
        animationDuration: const Duration(milliseconds: 200),
        side: const WidgetStatePropertyAll(
          BorderSide(color: Colors.grey, width: 0.25),
        ),
      ),
    ),
    cupertinoOverrideTheme: const NoDefaultCupertinoThemeData(
      brightness: Brightness.dark,
    ),
    extensions: {
      BartBrandColours(
        logoColor: red1,
        logoBackgroundColor: BartAppTheme.black2,
        loginBtnTextColor: Colors.white,
        loginBtnBackgroundColor: red1,
      ),
      BartChatBubbleStyle(
        senderTextColor: Colors.black,
        senderBackgroundColor: red2,
        receiverTextColor: red2,
        receiverBackgroundColor: Colors.black,
        textStyle: BartTextTheme.globalTextTheme.labelSmall!.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 12.spMin,
        ),
        senderContextBackgroundColor: Colors.white,
        receiverContextBackgroundColor: red2,
        senderContextTextColor: Colors.black,
        receiverContextTextColor: Colors.black,
        unreadTickColour: Colors.blue.shade200,
        readTickColour: Colors.blue.shade300,
      ),
      BartTradeWidgetStyle(
        incomingTextColour: red8,
        incomingBackgroundColour: Colors.black,
        incomingShadowColour: red8,
        outgoingTextColour: blue2,
        outgoingBackgroundColour: Colors.black,
        outgoingShadowColour: blue2,
        tbcTextColour: purple3,
        tbcBackgroundColour: Colors.black,
        tbcShadowColour: purple3,
        completeFailTextColour: Colors.red,
        completeFailBackgroundColour: Colors.black,
        completeFailShadowColour: Colors.red,
        tradeHistoryTextColour: Colors.white,
        tradeHistoryBackgroundColour: Colors.black,
        tradeHistoryShadowColour: Colors.white,
      ),
      BartMarketListItemStyle(
        splashColor: Colors.grey.withOpacity(0.2),
        titleColor: red1,
        cardTheme: CardTheme(
          color: Colors.black,
          surfaceTintColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          clipBehavior: Clip.antiAlias,
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
        ),
      ),
      BartTabButtonStyle(
        enabledElevation: 0,
        enabledBackgroundColor: red1.withOpacity(0.5),
        enabledForegroundColor: Colors.black.withOpacity(0.5),
        disabledElevation: 10,
        disabledBackgroundColor: red1,
        disabledForegroundColor: Colors.black,
      ),
      BartMaterialButtonStyle(
        backgroundColor: Colors.black,
        textColor: red1,
        splashColor: Colors.transparent,
        elevatedShadowColor: red1.withOpacity(0.85),
      ),
      BartMaterialButtonStyleGreen(
        buttonStyle: BartMaterialButtonStyle(
          backgroundColor: Colors.black,
          textColor: green2,
          splashColor: Colors.transparent,
          elevatedShadowColor: green2.withOpacity(0.85),
        ),
      ),
      BartMaterialButtonDisabledStyle(
        buttonStyle: BartMaterialButtonStyle(
          backgroundColor: Colors.black,
          textColor: Colors.grey,
          splashColor: Colors.transparent,
          elevatedShadowColor: Colors.grey.withOpacity(0.85),
        ),
      ),
      BartShimmerLoadStyle(
        baseColor: Colors.grey[850]!,
        highlightColor: Colors.grey,
      ),
      BartThemeModeToggleStyle(
        iconColor: red1,
        indicatorColor: Colors.white.withOpacity(0.4),
        backgroundColor: Colors.black,
      ),
      BartProfilePageColourStyle(
        gradientColourTop: red1,
        gradientColourBottom: purple1,
        containerColor: Colors.black,
        profileInfoCardColor: black1,
        textColor: Colors.white,
      ),
      BartPaymentPageStyle(
        currencyDropdownBackgroundColor: Colors.grey,
        currencyDropdownIconColor: Colors.white,
        currencyDropdownTextColor: Colors.black,
        textFieldBackgroundColor: Colors.black,
        textFieldTextColor: Colors.white,
      ),
      BartTutorialContentStyle(
        contentTextColour: Colors.white,
        contentBackgroundColour: black2,
        overlayShadowColour: Colors.red,
        buttonTextColor: Colors.red,
      ),
      BartSegmentSliderStyle(
        iconColour: Colors.grey,
        selectedIconColour: Colors.black,
        thumbColor: red1,
        backgroundColor: grey1,
      ),
      TradeWidgetBadgeStyle(
        badgeColor: red1,
        selectedBadgeColor: black2,
        labelColor: black2,
        selectedLabelColor: red1,
      ),
    },
  );
}

class BartTextTheme {
  BartTextTheme._();

  static const TextStyle logoStyle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 25,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle headingStyle = TextStyle(
    fontFamily: 'Merriwether Sans',
    fontSize: 26,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle bodyStyle1 = TextStyle(
    fontFamily: 'Jaldi',
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle labelStyle = TextStyle(
    fontFamily: 'Jost',
    fontSize: 20,
    fontWeight: FontWeight.normal,
  );

  // text heirarchy: display > headline > title > body > label

  static TextTheme globalTextTheme = TextTheme(
    displayLarge: BartTextTheme.headingStyle.copyWith(fontSize: 30),
    displayMedium: BartTextTheme.headingStyle.copyWith(fontSize: 26),
    displaySmall: BartTextTheme.headingStyle.copyWith(fontSize: 22),
    ///////////////////////////////////////////////////////////////////////
    headlineLarge: BartTextTheme.headingStyle.copyWith(fontSize: 30),
    headlineMedium: BartTextTheme.headingStyle.copyWith(fontSize: 26),
    headlineSmall: BartTextTheme.headingStyle.copyWith(fontSize: 22),
    ///////////////////////////////////////////////////////////////////////
    titleLarge: BartTextTheme.logoStyle.copyWith(fontSize: 120),
    titleMedium: BartTextTheme.logoStyle.copyWith(fontSize: 26),
    titleSmall: BartTextTheme.logoStyle.copyWith(fontSize: 22),
    ///////////////////////////////////////////////////////////////////////
    bodyLarge: BartTextTheme.bodyStyle1.copyWith(fontSize: 20),
    bodyMedium: BartTextTheme.bodyStyle1.copyWith(fontSize: 18),
    bodySmall: BartTextTheme.bodyStyle1.copyWith(fontSize: 16),
    ///////////////////////////////////////////////////////////////////////
    labelLarge: BartTextTheme.labelStyle.copyWith(fontSize: 20),
    labelMedium: BartTextTheme.labelStyle.copyWith(fontSize: 18),
    labelSmall: BartTextTheme.labelStyle.copyWith(fontSize: 16),
  );
}
