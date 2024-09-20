import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:bart_app/firebase_options.dart';
import 'package:bart_app/styles/bart_themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bart_app/common/utility/index.dart';
import 'package:bart_app/common/providers/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:bart_app/common/widgets/tutorial/bart_tutorial_coach.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then(BartAnalyticsEngine.init);
  BartAnalyticsEngine.logAppOpen();
  BartFirestoreServices();
  BartFirebaseStorageServices();
  BartFirebaseMessaging.init();
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
        BartAnalyticsEngine.logAppClose();
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
                  textScaler: const TextScaler.linear(1.0),
                ),
                child: child!,
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
