import 'package:flutter_test/flutter_test.dart';
import 'package:bart_app/common/extensions/ext_trade.dart';
import 'package:bart_app/common/constants/enum_trade_comp_types.dart';

import '../../helpers/fixtures.dart';

/// The two sides of every fixture trade.
const String trader = 'u-trader'; // owns tradedItem — listed it on the market
const String tradee = 'u-tradee'; // owns offeredItem — made the offer
const String stranger = 'u-stranger'; // involved in neither side

void main() {
  group('TradeTypeChecker.isTrader / isTradee', () {
    final trade = buildTrade(traderID: trader, tradeeID: tradee);

    test('identifies the owner of the traded item as the trader', () {
      expect(trade.isTrader(trader), isTrue);
      expect(trade.isTrader(tradee), isFalse);
      expect(trade.isTrader(stranger), isFalse);
    });

    test('identifies the owner of the offered item as the tradee', () {
      expect(trade.isTradee(tradee), isTrue);
      expect(trade.isTradee(trader), isFalse);
      expect(trade.isTradee(stranger), isFalse);
    });

    test('isUserInTrade covers both sides but excludes everyone else', () {
      expect(trade.isUserInTrade(trader), isTrue);
      expect(trade.isUserInTrade(tradee), isTrue);
      expect(trade.isUserInTrade(stranger), isFalse);
    });
  });

  group('TradeTypeChecker.acceptedByBoth', () {
    test('requires both parties', () {
      expect(
        buildTrade(
          acceptedByTrader: true,
          acceptedByTradee: true,
        ).acceptedByBoth(),
        isTrue,
      );
      expect(
        buildTrade(
          acceptedByTrader: true,
          acceptedByTradee: false,
        ).acceptedByBoth(),
        isFalse,
      );
      expect(
        buildTrade(
          acceptedByTrader: false,
          acceptedByTradee: true,
        ).acceptedByBoth(),
        isFalse,
      );
      expect(buildTrade().acceptedByBoth(), isFalse);
    });
  });

  group('TradeTypeChecker.isIncomingTrade', () {
    test('is true for the trader on an open, unaccepted trade', () {
      final trade = buildTrade(
        traderID: trader,
        tradeeID: tradee,
        isAccepted: false,
        isCompleted: false,
      );

      expect(trade.isIncomingTrade(trader), isTrue);
    });

    test('is false for the tradee, who sees the same trade as outgoing', () {
      final trade = buildTrade(traderID: trader, tradeeID: tradee);

      expect(trade.isIncomingTrade(tradee), isFalse);
    });

    test('is false once the trade has been accepted', () {
      final trade = buildTrade(traderID: trader, isAccepted: true);

      expect(trade.isIncomingTrade(trader), isFalse);
    });

    test('is false once the trade has been completed', () {
      final trade = buildTrade(traderID: trader, isCompleted: true);

      expect(trade.isIncomingTrade(trader), isFalse);
    });
  });

  group('TradeTypeChecker.isOutgoingTrade', () {
    test('is true for the tradee on an open, unaccepted trade', () {
      final trade = buildTrade(traderID: trader, tradeeID: tradee);

      expect(trade.isOutgoingTrade(tradee), isTrue);
    });

    test('is false for the trader', () {
      final trade = buildTrade(traderID: trader, tradeeID: tradee);

      expect(trade.isOutgoingTrade(trader), isFalse);
    });

    test('is false once accepted or completed', () {
      expect(
        buildTrade(tradeeID: tradee, isAccepted: true).isOutgoingTrade(tradee),
        isFalse,
      );
      expect(
        buildTrade(tradeeID: tradee, isCompleted: true).isOutgoingTrade(tradee),
        isFalse,
      );
    });

    test('incoming and outgoing are two views of one trade', () {
      final trade = buildTrade(traderID: trader, tradeeID: tradee);

      expect(
        trade.isIncomingTrade(trader) && trade.isOutgoingTrade(tradee),
        isTrue,
      );
      expect(
        trade.isIncomingTrade(trader) && trade.isOutgoingTrade(trader),
        isFalse,
      );
    });
  });

  group('TradeTypeChecker.isTBCTrade', () {
    test(
      'is true for either party once accepted but not yet confirmed by both',
      () {
        final trade = buildTrade(
          traderID: trader,
          tradeeID: tradee,
          isAccepted: true,
          acceptedByTrader: true,
          acceptedByTradee: false,
          isCompleted: false,
        );

        expect(trade.isTBCTrade(trader), isTrue);
        expect(trade.isTBCTrade(tradee), isTrue);
      },
    );

    test('is false for a stranger', () {
      final trade = buildTrade(
        traderID: trader,
        tradeeID: tradee,
        isAccepted: true,
        acceptedByTrader: true,
      );

      expect(trade.isTBCTrade(stranger), isFalse);
    });

    test('is false once both parties have confirmed', () {
      final trade = buildTrade(
        traderID: trader,
        isAccepted: true,
        acceptedByTrader: true,
        acceptedByTradee: true,
      );

      expect(trade.isTBCTrade(trader), isFalse);
    });

    test('is false once completed', () {
      final trade = buildTrade(
        traderID: trader,
        isAccepted: true,
        acceptedByTrader: true,
        isCompleted: true,
      );

      expect(trade.isTBCTrade(trader), isFalse);
    });
  });

  group('TradeTypeChecker.isCompletedTrade', () {
    test('is true for a completed trade both parties confirmed', () {
      final trade = buildTrade(
        isCompleted: true,
        isAccepted: true,
        acceptedByTrader: true,
        acceptedByTradee: true,
      );

      expect(trade.isCompletedTrade(trader), isTrue);
    });

    test('is true for a completed trade nobody accepted (a failed trade)', () {
      final trade = buildTrade(
        isCompleted: true,
        isAccepted: false,
        acceptedByTrader: false,
        acceptedByTradee: false,
      );

      expect(trade.isCompletedTrade(trader), isTrue);
    });

    test('is false for a completed trade in a half-accepted state', () {
      // isAccepted true but only one side confirmed satisfies neither branch.
      final trade = buildTrade(
        isCompleted: true,
        isAccepted: true,
        acceptedByTrader: true,
        acceptedByTradee: false,
      );

      expect(trade.isCompletedTrade(trader), isFalse);
    });

    test('is false while the trade is still open', () {
      expect(buildTrade().isCompletedTrade(trader), isFalse);
    });

    test('ignores the userID entirely', () {
      // Unlike every other predicate here, isCompletedTrade takes a userID it
      // never reads, so a stranger gets the same answer as a participant.
      // Callers must gate on isUserInTrade themselves.
      final trade = buildTrade(
        isCompleted: true,
        isAccepted: true,
        acceptedByTrader: true,
        acceptedByTradee: true,
      );

      expect(trade.isCompletedTrade(stranger), isTrue);
    });
  });

  group('TradeTypeChecker.getTradeCompType', () {
    test('an open trade is incoming for the trader', () {
      final trade = buildTrade(traderID: trader, tradeeID: tradee);

      expect(trade.getTradeCompType(trader), TradeCompType.incoming);
    });

    test('an open trade is outgoing for the tradee', () {
      final trade = buildTrade(traderID: trader, tradeeID: tradee);

      expect(trade.getTradeCompType(tradee), TradeCompType.outgoing);
    });

    test('an accepted, half-confirmed trade is toBeCompleted for both', () {
      final trade = buildTrade(
        traderID: trader,
        tradeeID: tradee,
        isAccepted: true,
        acceptedByTrader: true,
      );

      expect(trade.getTradeCompType(trader), TradeCompType.toBeCompleted);
      expect(trade.getTradeCompType(tradee), TradeCompType.toBeCompleted);
    });

    test('a completed, fully confirmed trade lands in tradeHistory', () {
      final trade = buildTrade(
        traderID: trader,
        tradeeID: tradee,
        isCompleted: true,
        isAccepted: true,
        acceptedByTrader: true,
        acceptedByTradee: true,
      );

      expect(trade.getTradeCompType(trader), TradeCompType.tradeHistory);
      expect(trade.getTradeCompType(tradee), TradeCompType.tradeHistory);
    });

    test('a completed, never-accepted trade is failed', () {
      final trade = buildTrade(
        traderID: trader,
        tradeeID: tradee,
        isCompleted: true,
        isAccepted: false,
      );

      expect(trade.getTradeCompType(trader), TradeCompType.failed);
      expect(trade.getTradeCompType(tradee), TradeCompType.failed);
    });

    test(
      'an accepted trade both parties confirmed but nobody completed is none',
      () {
        // Not incoming or outgoing (isAccepted), not TBC (acceptedByBoth) and not
        // completed — this state falls through every branch.
        final trade = buildTrade(
          traderID: trader,
          tradeeID: tradee,
          isAccepted: true,
          acceptedByTrader: true,
          acceptedByTradee: true,
          isCompleted: false,
        );

        expect(trade.getTradeCompType(trader), TradeCompType.none);
      },
    );

    test('an open trade is none for a stranger', () {
      final trade = buildTrade(traderID: trader, tradeeID: tradee);

      expect(trade.getTradeCompType(stranger), TradeCompType.none);
    });

    test('a finished trade still resolves for a stranger', () {
      // Follows from isCompletedTrade ignoring the userID — worth pinning so a
      // future fix there is a deliberate, visible change.
      final trade = buildTrade(
        traderID: trader,
        tradeeID: tradee,
        isCompleted: true,
        isAccepted: true,
        acceptedByTrader: true,
        acceptedByTradee: true,
      );

      expect(trade.getTradeCompType(stranger), TradeCompType.tradeHistory);
    });

    test('a completed, half-confirmed trade is none', () {
      final trade = buildTrade(
        traderID: trader,
        tradeeID: tradee,
        isCompleted: true,
        isAccepted: true,
        acceptedByTrader: true,
        acceptedByTradee: false,
      );

      expect(trade.getTradeCompType(trader), TradeCompType.none);
    });
  });

  group('TradeTypeChecker lifecycle', () {
    test('walks a trade from offer through to trade history', () {
      // The happy path as the two home-page tabs see it, step by step.
      var trade = buildTrade(traderID: trader, tradeeID: tradee);

      expect(trade.getTradeCompType(trader), TradeCompType.incoming);
      expect(trade.getTradeCompType(tradee), TradeCompType.outgoing);

      trade = trade.copyWith(isAccepted: true, acceptedByTrader: true);
      expect(trade.getTradeCompType(trader), TradeCompType.toBeCompleted);
      expect(trade.getTradeCompType(tradee), TradeCompType.toBeCompleted);

      trade = trade.copyWith(acceptedByTradee: true, isCompleted: true);
      expect(trade.getTradeCompType(trader), TradeCompType.tradeHistory);
      expect(trade.getTradeCompType(tradee), TradeCompType.tradeHistory);
    });

    test('walks a rejected trade through to failed', () {
      var trade = buildTrade(traderID: trader, tradeeID: tradee);

      expect(trade.getTradeCompType(trader), TradeCompType.incoming);

      trade = trade.copyWith(isCompleted: true);
      expect(trade.getTradeCompType(trader), TradeCompType.failed);
    });
  });
}
