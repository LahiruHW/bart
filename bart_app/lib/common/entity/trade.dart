// ignore_for_file: prefer_final_fields

import 'package:bart_app/common/entity/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bart_app/common/entity/trade_firestore.dart';
// import 'package:bart_app/common/typedefs/typedef_home_item.dart';
import 'package:bart_app/common/constants/enum_trade_comp_types.dart';

// class Trade extends HomeItem {
class Trade {
  Trade({
    required this.tradeID,
    required this.tradedItem, // owner Id is given in the item, string used for firestore
    required this.offeredItem, // owner Id is given in the item, string used for firestore
    required this.timeCreated,
    this.timeUpdated,
    this.isRead = false,
    this.isAccepted = false, // only used for incoming trades
    this.acceptedByTrader = false, // only used for successful trades
    this.acceptedByTradee = false, // only used for successful trades
    this.isCompleted = false, // USE TO SEE IF TRADE BELONGS IN TRADE HISTORY
    this.tradeCompType = TradeCompType.none,
    this.isNull = false,
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
  TradeCompType tradeCompType;
  bool isNull;

  @override
  bool operator ==(Object other) {
    if (other is Trade) {
      final result = tradeID == other.tradeID;
      return result;
    } else if (other is! Trade) {
      return identical(this, other);
    }
    return false;
  }

  @override
  int get hashCode => tradeID.hashCode;

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

  static final Trade _invalidObj = Trade(
    tradeID: "",
    tradedItem: Item.empty(),
    offeredItem: Item.empty(),
    timeCreated: Timestamp.now(),
    timeUpdated: Timestamp.now(),
    isRead: true,
    isAccepted: false,
    acceptedByTrader: false,
    acceptedByTradee: false,
    isCompleted: false,
    tradeCompType: TradeCompType.none,
    isNull: true,
  );

  factory Trade.empty() => _invalidObj;

  Trade copyWith({
    bool? isRead,
    bool? isAccepted,
    bool? acceptedByTrader,
    bool? acceptedByTradee,
    bool? isCompleted,
    Item? tradedItem,
    Item? offeredItem,
    Timestamp? timeCreated,
    Timestamp? timeUpdated,
    TradeCompType? tradeCompType,
  }) {
    return Trade(
      tradeID: tradeID,
      isRead: isRead ?? this.isRead,
      isAccepted: isAccepted ?? this.isAccepted,
      acceptedByTrader: acceptedByTrader ?? this.acceptedByTrader,
      acceptedByTradee: acceptedByTradee ?? this.acceptedByTradee,
      isCompleted: isCompleted ?? this.isCompleted,
      tradedItem: tradedItem ?? this.tradedItem,
      offeredItem: offeredItem ?? this.offeredItem,
      timeCreated: timeCreated ?? this.timeCreated,
      timeUpdated: timeUpdated ?? this.timeUpdated,
      tradeCompType: tradeCompType ?? this.tradeCompType,
    );
  }

  bool isSameDayAsTrade(Trade other) {
    final DateTime thisTime = timeCreated.toDate();
    final DateTime otherTime = other.timeCreated.toDate();
    return thisTime.day == otherTime.day &&
        thisTime.month == otherTime.month &&
        thisTime.year == otherTime.year;
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
      'Trade: $tradeID, traded: ${tradedItem.itemName}, offered: ${offeredItem.itemName}, timeCreated: $timeCreated, timeUpdated: $timeUpdated, tradeCompType: $tradeCompType';
}
