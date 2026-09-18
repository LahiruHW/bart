import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bart_app/main.dart' as app;
import 'package:bart_app/styles/bart_themes.dart';
import 'package:bart_app/common/widgets/icons/icon_exchange.dart';
import 'package:bart_app/common/widgets/buttons/bart_material_button.dart';
import 'package:bart_app/common/constants/enum_material_button_types.dart';

/// Opt in to the full `main()` boot with:
///
///     flutter test integration_test/app_test.dart --dart-define=BART_FULL_BOOT=true
///
/// It is off by default because `main()` contacts live Firebase (auth,
/// Firestore, remote config, messaging), so it needs real credentials and a
/// network, and it writes analytics events against the production project.
const bool kRunFullBoot = bool.fromEnvironment('BART_FULL_BOOT');

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Bart on-device smoke tests', () {
    // These run against the real engine on a real device or emulator, which is
    // what separates them from the widget tests under test/: real fonts, real
    // text shaping, real rasterisation, real gesture timing.

    testWidgets('the app theme resolves on device', (tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          ensureScreenSize: true,
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) => MaterialApp(
            theme: BartAppTheme.lightTheme,
            darkTheme: BartAppTheme.darkTheme,
            home: const Scaffold(body: Center(child: ExchangeIcon())),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ExchangeIcon), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('a themed button lays out and responds to a real tap', (
      tester,
    ) async {
      var taps = 0;

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          ensureScreenSize: true,
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) => MaterialApp(
            theme: BartAppTheme.lightTheme,
            home: Scaffold(
              body: Center(
                child: BartMaterialButton(
                  label: 'Continue',
                  icon: Icons.arrow_forward,
                  buttonType: BartMaterialButtonType.green,
                  onPressed: () => taps++,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Continue'), findsOneWidget);

      await tester.tap(find.byType(BartMaterialButton));
      await tester.pumpAndSettle();

      expect(taps, 1);
    });

    testWidgets('both themes render on device without exceptions', (
      tester,
    ) async {
      for (final mode in [ThemeMode.light, ThemeMode.dark]) {
        await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(375, 812),
            ensureScreenSize: true,
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) => MaterialApp(
              theme: BartAppTheme.lightTheme,
              darkTheme: BartAppTheme.darkTheme,
              themeMode: mode,
              home: Scaffold(
                body: Center(
                  child: BartMaterialButton(label: 'Themed', onPressed: () {}),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Themed'), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    });
  });

  group('Bart full application boot', () {
    testWidgets('main() boots as far as the login screen', (tester) async {
      await app.main();

      // main() starts long-lived animations (splash removal, shimmer), so
      // pumpAndSettle would never return. Pump a fixed budget instead.
      for (var i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 500));
      }

      expect(find.byType(MaterialApp), findsWidgets);
      expect(tester.takeException(), isNull);
    }, skip: !kRunFullBoot);
  });
}
