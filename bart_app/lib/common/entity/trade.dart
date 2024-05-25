import 'package:bart_app/common/entity/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bart_app/common/entity/trade_firestore.dart';
// import 'package:bart_app/common/typedefs/typedef_home_item.dart';

// class Trade extends HomeItem {
class Trade {
  Trade({
    required this.tradeID,
    required this.tradedItem, // owner Id is given in the item, string used for firestore
    required this.offeredItem, // owner Id is given in the item, string used for firestore
    required this.timeCreated,
    this.timeUpdated,
    this.isRead = false,
    this.isAccepted = false,      // only used for incoming trades
    this.acceptedByTrader = false,  // only used for successful trades
    this.acceptedByTradee = false,  // only used for successful trades
    this.isCompleted = false,
  });

  final String tradeID;
  bool isRead;
  bool isAccepted;
  bool acceptedByTrader;
  bool acceptedByTradee;
  bool isCompleted;
  final Item tradedItem;
  final Item offeredItem;
  final Timestamp timeCreated;
  Timestamp? timeUpdated;

  factory Trade.fromMap(Map<String, dynamic> data) {
    return Trade(
      tradeID: data['tradeID'],
      tradedItem: Item.fromMap(data['tradedItem']),
      offeredItem: Item.fromMap(data['offeredItem']),
      timeCreated: data['timeCreated'],
      timeUpdated: data['timeUpdated'],
      isRead: data['isRead'],
      isAccepted: data['isAccepted'],
      acceptedByTrader: data['acceptedByTrader'],
      acceptedByTradee: data['acceptedByTradee'],
      isCompleted: data['isCompleted'],
    );
  }

  factory Trade.fromFirestore(
      TradeFirestore tradeFirestore, Item tradedItem, Item offeredItem) {
    return Trade(
      tradeID: tradeFirestore.tradeID,
      tradedItem: tradedItem,
      offeredItem: offeredItem,
      timeCreated: tradeFirestore.timeCreated,
      timeUpdated: tradeFirestore.timeUpdated,
      isRead: tradeFirestore.isRead,
      isAccepted: tradeFirestore.isAccepted,
      acceptedByTrader: tradeFirestore.acceptedByTrader,
      acceptedByTradee: tradeFirestore.acceptedByTradee,
      isCompleted: tradeFirestore.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tradedItem': tradedItem.itemID,
      'offeredItem': offeredItem.itemID,
      'timeCreated': timeCreated,
      'timeUpdated': timeUpdated,
      'isRead': isRead,
      'isAccepted': isAccepted,
      'acceptedByTrader': acceptedByTrader,
      'acceptedByTradee': acceptedByTradee,
      'isCompleted': isCompleted,
    };
  }

  @override
  String toString() =>
      'Trade: $tradeID, traded: ${tradedItem.itemName}, offered: ${offeredItem.itemName}, timeCreated: $timeCreated, timeUpdated: $timeUpdated';
}
