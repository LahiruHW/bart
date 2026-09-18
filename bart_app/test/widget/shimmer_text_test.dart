import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bart_app/styles/bart_shimmer_load_style.dart';
import 'package:bart_app/common/widgets/shimmer/shimmer_text.dart';

import '../helpers/test_harness.dart';

/// The placeholder box the widget itself builds. Matched on `color` rather than
/// on `Container` alone, so an extra Container inside the shimmer package's own
/// tree could never be picked up by mistake.
final Finder _placeholderBox = find.descendant(
  of: find.byType(BartTextShimmer),
  matching: find.byWidgetPredicate(
    (widget) => widget is Container && widget.color != null,
  ),
);

void main() {
  // Shimmer runs a repeating animation, so every test here pumps with
  // settle: false — pumpAndSettle would spin until it times out.
  group('BartTextShimmer', () {
    testWidgets('renders a Shimmer placeholder', (tester) async {
      await pumpBartWidget(
        tester,
        const BartTextShimmer(textHeight: 12, textLength: 120),
        settle: false,
      );

      expect(find.byType(Shimmer), findsOneWidget);
    });

    testWidgets('sizes its placeholder box from the supplied dimensions', (
      tester,
    ) async {
      await pumpBartWidget(
        tester,
        const BartTextShimmer(textHeight: 12, textLength: 120),
        settle: false,
      );

      final box = tester.getSize(_placeholderBox);

      expect(box.width, 120);
      expect(box.height, 12);
    });

    testWidgets('takes its colours from the shimmer theme extension', (
      tester,
    ) async {
      await pumpBartWidget(
        tester,
        const BartTextShimmer(textHeight: 12, textLength: 120),
        settle: false,
      );

      final style = themeExtensionOf<BartShimmerLoadStyle>(tester);
      final container = tester.widget<Container>(_placeholderBox);

      expect(container.color, style.highlightColor);
    });

    testWidgets('renders in dark mode with the dark shimmer colours', (
      tester,
    ) async {
      await pumpBartWidget(
        tester,
        const BartTextShimmer(textHeight: 12, textLength: 120),
        settle: false,
        darkMode: true,
      );

      final darkStyle = themeExtensionOf<BartShimmerLoadStyle>(tester);
      final container = tester.widget<Container>(_placeholderBox);

      expect(find.byType(Shimmer), findsOneWidget);
      expect(container.color, darkStyle.highlightColor);
    });

    testWidgets('keeps animating across frames without throwing', (
      tester,
    ) async {
      await pumpBartWidget(
        tester,
        const BartTextShimmer(textHeight: 20, textLength: 200),
        settle: false,
      );

      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));

      expect(tester.takeException(), isNull);
      expect(find.byType(Shimmer), findsOneWidget);
    });

    testWidgets('handles a zero-width placeholder', (tester) async {
      await pumpBartWidget(
        tester,
        const BartTextShimmer(textHeight: 10, textLength: 0),
        settle: false,
      );

      expect(tester.takeException(), isNull);
    });
  });
}
