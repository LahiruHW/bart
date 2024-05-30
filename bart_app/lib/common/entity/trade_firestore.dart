
import 'package:cloud_firestore/cloud_firestore.dart';

class TradeFirestore {
  TradeFirestore({
    required this.tradeID,
    required this.tradedItem,
    required this.offeredItem,
    required this.timeCreated,
    required this.timeUpdated,
    this.isRead = false,
    this.isAccepted = false,
    this.acceptedByTrader = false,
    this.acceptedByTradee = false,
    this.isCompleted = false,
  });

  final String tradeID;
  final bool isRead;
  final bool isAccepted;
  final bool acceptedByTrader;
  final bool acceptedByTradee;
  final bool isCompleted;
  final String tradedItem;
  final String offeredItem;
  final Timestamp timeCreated;
  final Timestamp timeUpdated;

  @override
  bool operator ==(Object other) {
    if (other is TradeFirestore) {
      final result = tradeID == other.tradeID;
      return result;
    } else if (other is! TradeFirestore) {
      return identical(this, other);
    }
    return false;
  }

  @override
  int get hashCode => tradeID.hashCode;

  factory TradeFirestore.fromMap(Map<String, dynamic> data) {
    return TradeFirestore(
      tradeID: data['tradeID'],
      tradedItem: data['tradedItem'],
      offeredItem: data['offeredItem'],
      timeCreated: data['timeCreated'],
      timeUpdated: data['timeUpdated'],
      isRead: data['isRead'],
      isAccepted: data['isAccepted'],
      acceptedByTrader: data['acceptedByTrader'],
      acceptedByTradee: data['acceptedByTradee'],
      isCompleted: data['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tradedItem': tradedItem,
      'offeredItem': offeredItem,
      'timeCreated': timeCreated,
      'timeUpdated': timeUpdated,
      'isRead': isRead,
      'isAccepted': isAccepted,
      'acceptedByTrader': acceptedByTrader,
      'acceptedByTradee': acceptedByTradee,
      'isCompleted': isCompleted,
    };
  }
}
