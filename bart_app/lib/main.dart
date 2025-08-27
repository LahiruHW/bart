import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:bart_app/firebase_options.dart';
import 'package:bart_app/styles/bart_themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bart_app/common/utility/index.dart';
import 'package:bart_app/common/providers/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:bart_app/screens/shared/unsupported_device_screen.dart';
import 'package:bart_app/common/widgets/tutorial/bart_tutorial_coach.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // .then(BartAnalyticsEngine.init);
  // BartAnalyticsEngine.logAppOpen();
  BartFirestoreServices();
  BartFirebaseStorageServices();
  await BartLocalNotificationHandler.init();
  BartFirebaseNotificationHandler.init(); // don't put await here
  await BartAppVersionData.initPackageInfo();
  await BartAppUpdateChecker.initConfig();
  BartSharedPrefOps.initSharedPreferences();
  final appRuntime = MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => BartStateProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => TempStateProvider(),
      ),
    ],
    builder: (context, child) {
      BartTutorialCoach.createTutorial(context);
      return const BartApp();
    },
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // if any future issue arises, add a 2s time delay here again
  FlutterNativeSplash.remove();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
      ],
      path: 'assets/translations',
      child: appRuntime,
    ),
  );
}

class BartApp extends StatelessWidget {
  const BartApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        // BartAnalyticsEngine.logAppClose();
        BartRouteHandler.preExitCallbacks(context);
        return;
      },
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        ensureScreenSize: true,
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, widget) {
          return Consumer<BartStateProvider>(
            builder: (context, provider, child) => MaterialApp.router(
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: (kIsWeb) ? null : const TextScaler.linear(1.0),
                ),
                // child: child!,
                child: LayoutBuilder(
                  // key: UniqueKey(),
                  builder: (context, constraints) {
                    final w = constraints.maxWidth;
                    final h = constraints.maxHeight;
                    final aspectRatio = w / h;

                    // Restricting unsupported devices
                    final isSupportedAspectRatio = aspectRatio <= 1.5;
                    final isSmallScreen =
                        w <= 900 && h <= 1200; // Adjust for tablets

                    // return (aspectRatio <= 1.5)
                    //     ? child!
                    //     : const UnsupportedDeviceScreen();

                    // final isMobileOrTablet =
                    //     isSupportedAspectRatio && isSmallScreen;
                    // return (kIsWeb || !isMobileOrTablet)
                    //     ? const UnsupportedDeviceScreen()
                    //     : child!;

                    // return (!isSupportedAspectRatio || !isSmallScreen)
                    //     ? const UnsupportedDeviceScreen()
                    //     : child!;

                    return w > h ? const UnsupportedDeviceScreen() : child!;
                  },
                ),
              ),
              debugShowCheckedModeBanner: false,
              routerConfig: BartRouter.router,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              title: 'Bart',
              themeMode: provider.userProfile.settings!.isDarkMode
                  ? ThemeMode.dark
                  : ThemeMode.light,
              theme: BartAppTheme.lightTheme,
              darkTheme: BartAppTheme.darkTheme,
              themeAnimationDuration: const Duration(milliseconds: 800),
              themeAnimationCurve: Curves.easeInOut,
            ),
          );
        },
      ),
    );
  }
}
