import 'package:bart_app/common/entity/trade.dart';
import 'package:bart_app/common/constants/enum_trade_comp_types.dart';

extension TradeTypeChecker on Trade {
  bool isIncomingTrade(String userID) =>
      (!isAccepted && !isCompleted) && isTrader(userID);

  bool isOutgoingTrade(String userID) =>
      (!isAccepted && !isCompleted) && !isTradee(userID);

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
      return TradeCompType.tradeHistory;
    } else {
      return TradeCompType.none;
    }
  }
}
