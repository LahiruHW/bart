import 'package:bart_app/common/entity/item.dart';
import 'package:bart_app/common/entity/trade.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bart_app/common/widgets/home_trade_item.dart';
import 'package:bart_app/common/entity/user_local_profile.dart';
import 'package:bart_app/common/constants/enum_trade_comp_types.dart';

class HomeWidgetsExample {

  static TradeWidget _buildTradeWidget(
    Trade trade,
    TradeCompType tradeType,
    String userID,
  ) {
    return TradeWidget(
      trade: trade,
      tradeType: tradeType,
      userID: userID,
      onTap: () {},
    );
  }

  static final Item _sampleItem1 = Item(
    itemName: "",
    imgs: [],
    postedOn: Timestamp.now(),
    itemOwner: UserLocalProfile(userName: "John", userID: "123"),
    itemDescription: "",
  );
  static final Item _sampleItem2 = Item(
    itemName: "",
    imgs: [],
    postedOn: Timestamp.now(),
    itemOwner: UserLocalProfile(userName: "Sue", userID: "1234"),
    itemDescription: "",
  );

  static final Trade _sampleIncomingTrade = Trade(
    tradeID: "",
    tradedItem: Item.empty(),
    offeredItem: _sampleItem1,
    timeCreated: Timestamp.now(),
  );

  static final Trade _sampleOutgoingTrade = Trade(
    tradeID: "",
    tradedItem: _sampleItem1,
    offeredItem: Item.empty(),
    timeCreated: Timestamp.now(),
  );

  static final Trade _sampleTBCTrade1 = Trade(
    tradeID: "",
    tradedItem: _sampleItem2,
    offeredItem: _sampleItem1,
    isAccepted: true,
    timeCreated: Timestamp.now(),
  );

  static final Trade _sampleTBCTrade2 = Trade(
    tradeID: "",
    tradedItem: _sampleItem1,
    offeredItem: _sampleItem2,
    isAccepted: true,
    timeCreated: Timestamp.now(),
  );

  static TradeWidget buildIncomingTrade() {
    return _buildTradeWidget(_sampleIncomingTrade, TradeCompType.incoming, "");
  }

  static TradeWidget buildOutgoingTrade() {
    return _buildTradeWidget(_sampleOutgoingTrade, TradeCompType.outgoing, "");
  }

  static TradeWidget buildTBCTrade1() {
    return _buildTradeWidget(
        _sampleTBCTrade1, TradeCompType.toBeCompleted, "123");
  }

  static TradeWidget buildTBCTrade2() {
    return _buildTradeWidget(
        _sampleTBCTrade2, TradeCompType.toBeCompleted, "123");
  }

  static TradeWidget buildSTHTrade1() {
    return _buildTradeWidget(
        _sampleTBCTrade1, TradeCompType.tradeHistory, "123");
  }

  static TradeWidget buildSTHTrade2() {
    return _buildTradeWidget(
        _sampleTBCTrade2, TradeCompType.tradeHistory, "123");
  }
}
