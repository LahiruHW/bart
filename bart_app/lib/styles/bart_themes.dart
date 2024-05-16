import 'package:bart_app/styles/colour_switch_toggle_style.dart';
import 'package:flutter/material.dart';
import 'package:bart_app/styles/index.dart';

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
    backgroundColor: Colors.white, // red4
    // errorColor: Colors.red,
    // cardColor: red4,
    cardColor: Colors.white,
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
      selectedItemColor: red1,
      unselectedItemColor: Colors.black,
      type: BottomNavigationBarType.shifting, // looks cool
      // enableFeedback: true,
    ),
    expansionTileTheme: const ExpansionTileThemeData(
      backgroundColor: Colors.white,
      collapsedBackgroundColor: Colors.white,
      childrenPadding: EdgeInsets.symmetric(horizontal: 10),
      textColor: Colors.black,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStateProperty.all(
          BartTextTheme.globalTextTheme.labelLarge!.copyWith(
            color: Colors.black,
          ),
        ),
        backgroundColor: WidgetStateProperty.all(Colors.white),
        foregroundColor: WidgetStateProperty.all(Colors.black),
        surfaceTintColor: WidgetStateProperty.all(grey1),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        minimumSize: WidgetStateProperty.all(const Size(300, 60)),
        maximumSize: WidgetStateProperty.all(const Size(300, 60)),
        fixedSize: WidgetStateProperty.all(const Size(300, 60)),
      ),
    ),
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      dense: false,
      enableFeedback: true,
      titleTextStyle: BartTextTheme.globalTextTheme.bodyLarge!.copyWith(
        fontSize: 25,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      subtitleTextStyle: BartTextTheme.globalTextTheme.bodySmall!.copyWith(
        fontSize: 18,
        color: Colors.black.withOpacity(0.8),
        fontWeight: FontWeight.normal,
      ),
      leadingAndTrailingTextStyle:
          BartTextTheme.globalTextTheme.bodySmall!.copyWith(
        fontSize: 15,
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
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
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
        fontSize: 20,
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
          fontSize: 15,
        ),
      ),
      BartTradeWidgetStyle(
        incomingTextColour: Colors.white,
        incomingBackgroundColour: red1,
        incomingShadowColour: Colors.black.withOpacity(0.4),
        outgoingTextColour: red1,
        outgoingBackgroundColour: Colors.white,
        outgoingShadowColour: red1.withOpacity(0.8),
        completeSuccessTextColour: purple3,
        completeSuccessBackgroundColour: Colors.white,
        completeSuccessShadowColour: purple3.withOpacity(0.8),
        completeFailTextColour: Colors.red,
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
      BartMarketTabButtonStyle(
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
    },
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: darkColorScheme,
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
      selectedItemColor: red1,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.shifting, // looks cool
      // enableFeedback: true,
    ),
    expansionTileTheme: ExpansionTileThemeData(
      backgroundColor: black2,
      collapsedBackgroundColor: black2,
      childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
      textColor: Colors.white,
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
          ),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        minimumSize: WidgetStateProperty.all(const Size(300, 60)),
        maximumSize: WidgetStateProperty.all(const Size(300, 60)),
        fixedSize: WidgetStateProperty.all(const Size(300, 60)),
      ),
    ),
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      dense: false,
      enableFeedback: true,
      titleTextStyle: BartTextTheme.globalTextTheme.bodyLarge!.copyWith(
        fontSize: 25,
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
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
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
        fontSize: 20,
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
          fontSize: 15,
        ),
      ),
      BartTradeWidgetStyle(
        incomingTextColour: red8,
        incomingBackgroundColour: red8.withOpacity(0.15),
        incomingShadowColour: Colors.black,
        outgoingTextColour: blue2,
        outgoingBackgroundColour: blue2.withOpacity(0.15),
        outgoingShadowColour: Colors.black,
        completeSuccessTextColour: purple3,
        completeSuccessBackgroundColour: purple3.withOpacity(0.15),
        completeSuccessShadowColour: Colors.black,
        completeFailTextColour: Colors.red,
        completeFailBackgroundColour: Colors.grey,
        completeFailShadowColour: Colors.black.withOpacity(0.4),
        tradeHistoryTextColour: Colors.white,
        tradeHistoryBackgroundColour: black1,
        tradeHistoryShadowColour: Colors.black,
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
      BartMarketTabButtonStyle(
        enabledElevation: 0,
        enabledBackgroundColor: Colors.black.withOpacity(0.5),
        enabledForegroundColor: red1.withOpacity(0.5),
        disabledElevation: 10,
        disabledBackgroundColor: Colors.black,
        disabledForegroundColor: red1,
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
