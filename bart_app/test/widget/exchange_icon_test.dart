import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bart_app/common/widgets/icons/icon_exchange.dart';

import '../helpers/test_harness.dart';

void main() {
  group('ExchangeIcon', () {
    testWidgets('renders the compare-arrows glyph', (tester) async {
      await pumpBartWidget(tester, const ExchangeIcon());

      expect(find.byIcon(Icons.compare_arrows_rounded), findsOneWidget);
    });

    testWidgets('rotates the badge a quarter turn', (tester) async {
      await pumpBartWidget(tester, const ExchangeIcon());

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(ExchangeIcon),
          matching: find.byType(Container),
        ),
      );

      expect(container.transform, isNotNull);
      expect(container.transformAlignment, Alignment.center);
    });

    testWidgets('draws dark contrast on a light surface', (tester) async {
      await pumpBartWidget(tester, const ExchangeIcon());

      final icon = tester.widget<Icon>(
        find.byIcon(Icons.compare_arrows_rounded),
      );

      // The widget picks its colour from the surface luminance rather than from
      // the theme's onSurface, so light surfaces get a translucent black.
      expect(icon.color, isNotNull);
      expect(icon.color!.computeLuminance(), lessThan(0.5));
    });

    testWidgets('draws light contrast on a dark surface', (tester) async {
      await pumpBartWidget(tester, const ExchangeIcon(), darkMode: true);

      final icon = tester.widget<Icon>(
        find.byIcon(Icons.compare_arrows_rounded),
      );

      expect(icon.color, isNotNull);
      expect(icon.color!.computeLuminance(), greaterThan(0.5));
    });

    testWidgets('flips its contrast between the two themes', (tester) async {
      await pumpBartWidget(tester, const ExchangeIcon());
      final lightColor = tester
          .widget<Icon>(find.byIcon(Icons.compare_arrows_rounded))
          .color;

      await pumpBartWidget(tester, const ExchangeIcon(), darkMode: true);
      final darkColor = tester
          .widget<Icon>(find.byIcon(Icons.compare_arrows_rounded))
          .color;

      expect(lightColor, isNot(darkColor));
    });

    testWidgets('renders without layout errors', (tester) async {
      await pumpBartWidget(tester, const ExchangeIcon());

      expect(tester.takeException(), isNull);
      expect(find.byType(ExchangeIcon), findsOneWidget);
    });
  });
}
