import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bart_app/styles/bart_material_button_style.dart';
import 'package:bart_app/common/widgets/buttons/bart_material_button.dart';
import 'package:bart_app/common/constants/enum_material_button_types.dart';

import '../helpers/test_harness.dart';

void main() {
  group('BartMaterialButton rendering', () {
    testWidgets('shows its label', (tester) async {
      await pumpBartWidget(
        tester,
        BartMaterialButton(label: 'Confirm trade', onPressed: () {}),
      );

      expect(find.text('Confirm trade'), findsOneWidget);
    });

    testWidgets('shows no icon unless one is supplied', (tester) async {
      await pumpBartWidget(
        tester,
        BartMaterialButton(label: 'No icon', onPressed: () {}),
      );

      expect(find.byType(Icon), findsNothing);
    });

    testWidgets('shows the icon when one is supplied', (tester) async {
      await pumpBartWidget(
        tester,
        BartMaterialButton(
          label: 'With icon',
          icon: Icons.check,
          onPressed: () {},
        ),
      );

      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('renders in dark mode too', (tester) async {
      await pumpBartWidget(
        tester,
        BartMaterialButton(label: 'Dark', onPressed: () {}),
        darkMode: true,
      );

      expect(find.text('Dark'), findsOneWidget);
    });
  });

  group('BartMaterialButton interaction', () {
    testWidgets('fires onPressed when tapped', (tester) async {
      var taps = 0;

      await pumpBartWidget(
        tester,
        BartMaterialButton(label: 'Tap me', onPressed: () => taps++),
      );
      await tester.tap(find.byType(BartMaterialButton));
      await tester.pumpAndSettle();

      expect(taps, 1);
    });

    testWidgets('fires once per tap', (tester) async {
      var taps = 0;

      await pumpBartWidget(
        tester,
        BartMaterialButton(label: 'Tap me', onPressed: () => taps++),
      );
      await tester.tap(find.byType(BartMaterialButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(BartMaterialButton));
      await tester.pumpAndSettle();

      expect(taps, 2);
    });

    testWidgets('swallows taps when disabled', (tester) async {
      var taps = 0;

      await pumpBartWidget(
        tester,
        BartMaterialButton(
          label: 'Disabled',
          isEnabled: false,
          onPressed: () => taps++,
        ),
      );
      await tester.tap(find.byType(BartMaterialButton));
      await tester.pumpAndSettle();

      expect(taps, 0);
    });

    testWidgets('detaches the callback from the MaterialButton when disabled', (
      tester,
    ) async {
      await pumpBartWidget(
        tester,
        BartMaterialButton(
          label: 'Disabled',
          isEnabled: false,
          onPressed: () {},
        ),
      );

      final button = tester.widget<MaterialButton>(find.byType(MaterialButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('accepts a null onPressed without throwing', (tester) async {
      await pumpBartWidget(
        tester,
        const BartMaterialButton(label: 'Inert', onPressed: null),
      );
      await tester.tap(find.byType(BartMaterialButton));
      await tester.pumpAndSettle();

      expect(find.text('Inert'), findsOneWidget);
    });
  });

  group('BartMaterialButton theming', () {
    testWidgets('a normal button uses the base button style', (tester) async {
      await pumpBartWidget(
        tester,
        BartMaterialButton(
          label: 'Normal',
          buttonType: BartMaterialButtonType.normal,
          onPressed: () {},
        ),
      );

      final expected = themeExtensionOf<BartMaterialButtonStyle>(tester);
      final button = tester.widget<MaterialButton>(find.byType(MaterialButton));

      expect(button.color, expected.backgroundColor);
      expect(button.textColor, expected.textColor);
    });

    testWidgets('a green button uses the green style', (tester) async {
      await pumpBartWidget(
        tester,
        BartMaterialButton(
          label: 'Green',
          buttonType: BartMaterialButtonType.green,
          onPressed: () {},
        ),
      );

      final expected = themeExtensionOf<BartMaterialButtonStyleGreen>(
        tester,
      ).buttonStyle!;
      final button = tester.widget<MaterialButton>(find.byType(MaterialButton));

      expect(button.color, expected.backgroundColor);
    });

    testWidgets('isEnabled false overrides the requested button type', (
      tester,
    ) async {
      // A green-but-disabled button must look disabled, not green — the
      // isEnabled check runs before the type switch.
      await pumpBartWidget(
        tester,
        BartMaterialButton(
          label: 'Green but off',
          buttonType: BartMaterialButtonType.green,
          isEnabled: false,
          onPressed: () {},
        ),
      );

      final disabled = themeExtensionOf<BartMaterialButtonDisabledStyle>(
        tester,
      ).buttonStyle!;
      final button = tester.widget<MaterialButton>(find.byType(MaterialButton));

      expect(button.color, disabled.backgroundColor);
    });
  });

  group('BartMaterialButton label handling', () {
    testWidgets('caps a long label at two lines with an ellipsis', (
      tester,
    ) async {
      const label = 'A very long call to action that will not fit on one line';

      await pumpBartWidget(
        tester,
        BartMaterialButton(label: label, onPressed: () {}),
      );

      final text = tester.widget<Text>(find.text(label));
      expect(text.maxLines, 2);
      expect(text.overflow, TextOverflow.ellipsis);
    });

    testWidgets('lays out without overflowing its surface', (tester) async {
      await pumpBartWidget(
        tester,
        BartMaterialButton(
          label: 'A very long call to action that will not fit on one line',
          icon: Icons.check,
          onPressed: () {},
        ),
      );

      // pumpBartWidget would already have surfaced a RenderFlex overflow as a
      // test failure; this just asserts the button actually rendered.
      expect(find.byType(BartMaterialButton), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
