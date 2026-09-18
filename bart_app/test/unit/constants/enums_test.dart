import 'package:flutter_test/flutter_test.dart';
import 'package:bart_app/common/constants/enum_item_types.dart';
import 'package:bart_app/common/constants/enum_trade_types.dart';
import 'package:bart_app/common/constants/enum_login_types.dart';
import 'package:bart_app/common/constants/enum_trade_comp_types.dart';
import 'package:bart_app/common/constants/enum_user_request_types.dart';

void main() {
  group('TradeCompType', () {
    test('every value round-trips through its string form', () {
      for (final value in TradeCompType.values) {
        expect(TradeCompType.fromString(value.value), value);
      }
    });

    test('exposes the values the home page buckets trades into', () {
      expect(
        TradeCompType.values.map((e) => e.value),
        containsAll(<String>[
          'incoming',
          'outgoing',
          'toBeCompleted',
          'failed',
          'tradeHistory',
          'none',
        ]),
      );
    });

    test('rejects an unknown value rather than defaulting silently', () {
      expect(
        () => TradeCompType.fromString('somethingElse'),
        throwsA(isA<Exception>()),
      );
    });

    test('rejects an empty string', () {
      expect(() => TradeCompType.fromString(''), throwsA(isA<Exception>()));
    });

    test('is case-sensitive', () {
      expect(
        () => TradeCompType.fromString('Incoming'),
        throwsA(isA<Exception>()),
      );
    });

    test('toString is prefixed for readable debug output', () {
      expect(TradeCompType.incoming.toString(), 'TradeCompletionType.incoming');
    });
  });

  group('ItemType', () {
    test('every value round-trips through its string form', () {
      for (final value in ItemType.values) {
        expect(ItemType.fromString(value.value), value);
      }
    });

    test('separates real objects from money payments', () {
      expect(ItemType.object.value, 'object');
      expect(ItemType.money.value, 'money');
      expect(ItemType.values, hasLength(2));
    });

    test('rejects an unknown value', () {
      expect(() => ItemType.fromString('service'), throwsA(isA<Exception>()));
    });

    test('toString is prefixed for readable debug output', () {
      expect(ItemType.money.toString(), 'ItemType.money');
    });
  });

  group('enum value uniqueness', () {
    test('no TradeCompType shares a string with another', () {
      final values = TradeCompType.values.map((e) => e.value).toList();

      expect(values.toSet(), hasLength(values.length));
    });

    test('no ItemType shares a string with another', () {
      final values = ItemType.values.map((e) => e.value).toList();

      expect(values.toSet(), hasLength(values.length));
    });
  });

  group('enum surfaces stay populated', () {
    // These guard against an enum being emptied or renamed out from under the
    // switch statements that fan out over them.
    test('TradeType has values', () {
      expect(TradeType.values, isNotEmpty);
    });

    test('LoginType has values', () {
      expect(LoginType.values, isNotEmpty);
    });

    test('UserReqType has values', () {
      expect(UserReqType.values, isNotEmpty);
    });
  });
}
