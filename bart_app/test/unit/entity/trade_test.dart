import 'package:flutter_test/flutter_test.dart';
import 'package:bart_app/common/entity/item.dart';
import 'package:bart_app/common/entity/trade.dart';
import 'package:bart_app/common/constants/enum_trade_comp_types.dart';

import '../../helpers/fixtures.dart';

void main() {
  group('Trade equality', () {
    test('two trades with the same id are equal, whatever else differs', () {
      final a = buildTrade(tradeID: 'trade-7', isAccepted: false);
      final b = buildTrade(
        tradeID: 'trade-7',
        isAccepted: true,
        isCompleted: true,
      );

      expect(a == b, isTrue);
      expect(a.hashCode, b.hashCode);
    });

    test('two trades with different ids are not equal', () {
      expect(buildTrade(tradeID: 'a') == buildTrade(tradeID: 'b'), isFalse);
    });

    test('a trade is never equal to a non-Trade', () {
      expect(buildTrade() == 'trade-1', isFalse);
    });

    test('id-based equality makes trades usable as Set members', () {
      final set = {
        buildTrade(tradeID: 'trade-1'),
        buildTrade(tradeID: 'trade-1', isAccepted: true),
        buildTrade(tradeID: 'trade-2'),
      };

      expect(set.length, 2);
    });
  });

  group('Trade.fromMap', () {
    test('rebuilds both nested items and every flag', () {
      final ownerMap = {
        'userID': 'owner-1',
        'userName': 'erin',
        'fullName': 'Erin Evans',
        'chats': <String>[],
        'isFirstLogin': false,
        'imageUrl': null,
        'settings': {
          'isDarkMode': false,
          'isLegacyUI': false,
          'lastUpdated': kFixedTimestamp,
          'lastUpdatedString': kFixedTimestamp.toDate().toIso8601String(),
        },
        'localeString': 'en',
        'lastUpdated': kFixedTimestamp,
        'fcmToken': '',
      };

      Map<String, dynamic> itemMap(String id, String name) => {
        'itemId': id,
        'itemName': name,
        'itemDescription': 'desc',
        'itemOwner': ownerMap,
        'imgs': <String>[],
        'preferredInReturn': <String>[],
        'postedOn': kFixedTimestamp,
        'isListedInMarket': true,
        'isPayment': false,
      };

      final trade = Trade.fromMap({
        'tradeID': 'trade-3',
        'tradedItem': itemMap('traded-1', 'Traded'),
        'offeredItem': itemMap('offered-1', 'Offered'),
        'timeCreated': kFixedTimestamp,
        'timeUpdated': kNextDayTimestamp,
        'isRead': true,
        'isAccepted': true,
        'acceptedByTrader': true,
        'acceptedByTradee': false,
        'isCompleted': false,
      });

      expect(trade.tradeID, 'trade-3');
      expect(trade.tradedItem.itemName, 'Traded');
      expect(trade.offeredItem.itemName, 'Offered');
      expect(trade.timeCreated, kFixedTimestamp);
      expect(trade.timeUpdated, kNextDayTimestamp);
      expect(trade.isRead, isTrue);
      expect(trade.isAccepted, isTrue);
      expect(trade.acceptedByTrader, isTrue);
      expect(trade.acceptedByTradee, isFalse);
      expect(trade.isCompleted, isFalse);
    });

    test('leaves tradeCompType at none, since the map does not carry it', () {
      // tradeCompType is derived per-viewer by TradeTypeChecker rather than
      // stored, so a freshly deserialised trade always starts at none.
      final trade = buildTrade();

      expect(trade.tradeCompType, TradeCompType.none);
    });
  });

  group('Trade.empty', () {
    test('is flagged as null and holds empty items', () {
      final empty = Trade.empty();

      expect(empty.isNull, isTrue);
      expect(empty.tradeID, isEmpty);
      expect(empty.tradedItem.isNull, isTrue);
      expect(empty.offeredItem.isNull, isTrue);
      expect(empty.tradeCompType, TradeCompType.none);
      expect(
        empty.isRead,
        isTrue,
        reason: 'placeholder should not look unread',
      );
    });

    test('hands back one shared instance, not a fresh copy per call', () {
      expect(identical(Trade.empty(), Trade.empty()), isTrue);
    });
  });

  group('Trade.copyWith', () {
    test('overrides only the fields it is given', () {
      final original = buildTrade(
        tradeID: 'trade-9',
        isRead: false,
        isAccepted: false,
        isCompleted: false,
      );

      final updated = original.copyWith(isAccepted: true);

      expect(updated.tradeID, 'trade-9');
      expect(updated.isAccepted, isTrue);
      expect(updated.isRead, isFalse);
      expect(updated.isCompleted, isFalse);
      expect(updated.tradedItem, same(original.tradedItem));
      expect(updated.offeredItem, same(original.offeredItem));
      expect(updated.timeCreated, original.timeCreated);
    });

    test('can swap the items on a trade', () {
      final original = buildTrade();
      final replacement = buildItem(
        itemID: 'replacement',
        itemName: 'Replacement',
      );

      final updated = original.copyWith(offeredItem: replacement);

      expect(updated.offeredItem.itemName, 'Replacement');
      expect(updated.tradedItem.itemName, 'Traded Item');
    });

    test('can move a trade into a completion bucket', () {
      final updated = buildTrade().copyWith(
        isCompleted: true,
        isAccepted: true,
        acceptedByTrader: true,
        acceptedByTradee: true,
        tradeCompType: TradeCompType.tradeHistory,
      );

      expect(updated.isCompleted, isTrue);
      expect(updated.tradeCompType, TradeCompType.tradeHistory);
    });
  });

  group('Trade.isSameDayAsTrade', () {
    test('is true for two trades created on the same calendar day', () {
      final a = buildTrade(tradeID: 'a', timeCreated: kFixedTimestamp);
      final b = buildTrade(tradeID: 'b', timeCreated: kSameDayTimestamp);

      expect(a.isSameDayAsTrade(b), isTrue);
      expect(b.isSameDayAsTrade(a), isTrue);
    });

    test('is false across a day boundary', () {
      final a = buildTrade(tradeID: 'a', timeCreated: kFixedTimestamp);
      final b = buildTrade(tradeID: 'b', timeCreated: kNextDayTimestamp);

      expect(a.isSameDayAsTrade(b), isFalse);
    });

    test('is true when compared against itself', () {
      final trade = buildTrade();

      expect(trade.isSameDayAsTrade(trade), isTrue);
    });
  });

  group('Trade.toMap', () {
    test('flattens both items down to their ids', () {
      final trade = buildTrade();

      final map = trade.toMap();

      expect(map['tradedItem'], 'traded-item');
      expect(map['offeredItem'], 'offered-item');
    });

    test('writes every acceptance flag', () {
      final map = buildTrade(
        isRead: true,
        isAccepted: true,
        acceptedByTrader: true,
        acceptedByTradee: false,
        isCompleted: false,
      ).toMap();

      expect(map['isRead'], isTrue);
      expect(map['isAccepted'], isTrue);
      expect(map['acceptedByTrader'], isTrue);
      expect(map['acceptedByTradee'], isFalse);
      expect(map['isCompleted'], isFalse);
    });

    test('omits the tradeID and the derived tradeCompType', () {
      final map = buildTrade(tradeCompType: TradeCompType.incoming).toMap();

      expect(map.containsKey('tradeID'), isFalse);
      expect(map.containsKey('tradeCompType'), isFalse);
    });
  });

  group('Trade.toString', () {
    test('names both items so debug output is readable', () {
      final text = buildTrade(tradeID: 'trade-5').toString();

      expect(text, contains('trade-5'));
      expect(text, contains('Traded Item'));
      expect(text, contains('Offered Item'));
    });
  });

  group('Trade item wiring', () {
    test('the fixture puts each side under a different owner', () {
      // Every TradeTypeChecker predicate depends on this split, so it is worth
      // failing loudly here rather than in each extension test.
      final trade = buildTrade(traderID: 'u-trader', tradeeID: 'u-tradee');

      expect(trade.tradedItem.itemOwner.userID, 'u-trader');
      expect(trade.offeredItem.itemOwner.userID, 'u-tradee');
      expect(trade.tradedItem, isA<Item>());
    });
  });
}
