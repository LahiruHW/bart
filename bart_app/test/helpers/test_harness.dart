import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bart_app/styles/bart_themes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// The design size the real app is laid out against in [main.dart].
/// Widget tests must use the same one, otherwise every `.w` / `.h` / `.spMin`
/// in the widget tree resolves to a different value than it does in the app.
const Size kBartDesignSize = Size(375, 812);

/// Pumps [child] inside the same scaffolding the real app gives its widgets:
/// a [ScreenUtilInit] (so the `.w` / `.h` / `.spMin` extensions resolve) and a
/// [MaterialApp] carrying [BartAppTheme], whose `ThemeExtension`s nearly every
/// Bart widget reads via `Theme.of(context).extension<...>()!`.
///
/// [BartAppTheme.lightTheme] is a lazily-initialised static that itself calls
/// `.spMin`, so it must not be touched before ScreenUtil is initialised — that
/// is why the themes are only referenced from inside the [ScreenUtilInit]
/// builder below.
///
/// Set [settle] to `false` for widgets that animate forever (anything built on
/// `Shimmer`, `flutter_animate` loops, etc.); `pumpAndSettle` never returns for
/// those and the test fails with a timeout instead of a useful message.
Future<void> pumpBartWidget(
  WidgetTester tester,
  Widget child, {
  bool darkMode = false,
  bool settle = true,
  Size surfaceSize = kBartDesignSize,
}) async {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = surfaceSize;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: kBartDesignSize,
      ensureScreenSize: true,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, widget) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: BartAppTheme.lightTheme,
        darkTheme: BartAppTheme.darkTheme,
        themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
        home: Scaffold(body: Center(child: child)),
      ),
    ),
  );

  if (settle) {
    await tester.pumpAndSettle();
  } else {
    // ScreenUtilInit needs a second frame before its builder output is laid out.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  }
}

/// Reads a `ThemeExtension` out of the pumped tree the same way the widgets do,
/// so assertions can compare against the real themed value instead of a
/// hardcoded colour that drifts the moment the theme is edited.
T themeExtensionOf<T extends ThemeExtension<T>>(WidgetTester tester) {
  final context = tester.element(find.byType(Scaffold));
  return Theme.of(context).extension<T>()!;
}
