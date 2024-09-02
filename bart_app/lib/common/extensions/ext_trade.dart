import 'package:bart_app/common/entity/trade.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bart_app/common/constants/enum_trade_comp_types.dart';

extension TradeTypeChecker on Trade {

  bool isTrader(String userID) => tradedItem.itemOwner.userID == userID;
  bool isTradee(String userID) => offeredItem.itemOwner.userID == userID;

  bool isUserInTrade(String userID) {
    return tradedItem.itemOwner.userID == userID ||
        offeredItem.itemOwner.userID == userID;
  }

  bool acceptedByBoth() => acceptedByTrader && acceptedByTradee;

  bool isIncomingTrade(String userID) =>
      (!isAccepted && !isCompleted) && isTrader(userID);

  bool isOutgoingTrade(String userID) =>
      (!isAccepted && !isCompleted) && isTradee(userID);

  bool isTBCTrade(String userID) =>
      (!isCompleted) &&
      (isAccepted) &&
      !acceptedByBoth() &&
      isUserInTrade(userID);

  bool isCompletedTrade(String userID) =>
      (isCompleted && isAccepted && acceptedByBoth()) ||
      (isCompleted && !isAccepted && !acceptedByBoth());

  TradeCompType getTradeCompType(String userID) {
    if (isIncomingTrade(userID)) {
      return TradeCompType.incoming;
    } else if (isOutgoingTrade(userID)) {
      return TradeCompType.outgoing;
    } else if (isTBCTrade(userID)) {
      return TradeCompType.toBeCompleted;
    } else if (isCompletedTrade(userID)) {
      if (isCompleted) {
        return (isAccepted && acceptedByBoth())
            ? TradeCompType.tradeHistory
            : TradeCompType.failed;
      } else {
        return TradeCompType.none;
      }
    } else {
      return TradeCompType.none;
    }
  }

  (String, String) getTradeItemLabels() {
    final trader = tradedItem.itemOwner.userName;
    final tradee = offeredItem.itemOwner.userName;
    switch (tradeCompType) {
      case TradeCompType.incoming:
        return (
          tr('view.trade.page.incoming.label1'),
          tr(
            'view.trade.page.incoming.label2',
            namedArgs: {'itemOwner': tradee},
          ),
        );
      case TradeCompType.outgoing:
        return (
          tr(
            'view.trade.page.outgoing.label1',
            namedArgs: {'itemOwner': trader},
          ),
          tr('view.trade.page.outgoing.label2'),
        );
      case TradeCompType.toBeCompleted:
        return (
          tr(
            'view.trade.page.successful.label1',
            namedArgs: {'itemOwner': trader},
          ),
          tr(
            'view.trade.page.successful.label2',
            namedArgs: {'tradee': tradee, 'trader': trader},
          ),
        );
      case TradeCompType.failed:
        return (
          tr(
            'view.trade.page.completeFailed.label1',
            namedArgs: {'itemOwner': trader},
          ),
          tr(
            'view.trade.page.completeFailed.label2',
            namedArgs: {'tradee': tradee, 'trader': trader},
          ),
        );
      default:
        return (
          tr(
            'view.trade.page.default.label1',
            namedArgs: {'itemOwner': trader},
          ),
          tr(
            'view.trade.page.default.label2',
            namedArgs: {'itemOwner': tradee},
          ),
        );
    }
  }
}
