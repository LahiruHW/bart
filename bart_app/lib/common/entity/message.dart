import 'package:bart_app/common/entity/item.dart';
import 'package:bart_app/common/entity/trade.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  Message({
    this.messageID = "",
    required this.timeSent,
    required this.senderID,
    this.senderName = "",
    required this.text,
    this.isSharedTrade = false,
    this.isRead = false,
    this.isSharedItem = false,
    this.extra = const {},
  });

  final String messageID;
  final Timestamp timeSent;
  final String senderID;
  String senderName;
  final String text;
  bool? isSharedTrade;
  bool? isRead;
  bool? isSharedItem;
  final Map<String, dynamic> extra;

  factory Message.fromMap(Map<String, dynamic> json) {
    return Message(
      messageID: json['msgID'],
      timeSent: json['timeSent'],
      senderID: json['senderID'],
      senderName: json['senderName'],
      text: json['text'],
      isSharedTrade: json['isSharedTrade'],
      isSharedItem: json['isSharedItem'],
      isRead: json['isRead'],
      extra: json['extra'] as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'timeSent': timeSent,
      'senderID': senderID,
      'senderName': senderName,
      'text': text,
      'isSharedTrade': isSharedTrade,
      'isSharedItem': isSharedItem,
      'isRead': isRead,
      'extra': _extraToMap(),
    };
  }

  Map<String, dynamic> _extraToMap() {
    if (isSharedItem!) {
      final itemContent = extra['itemContent'] as Item;
      return {
        'itemContent': itemContent.itemID,
      };
    }
    if (isSharedTrade!) {
      final tradeContent = extra['tradeContent'] as Trade;
      return {
        'tradeContent': tradeContent.tradeID,
      };
    }
    return extra;
  }

  bool isSameDayAsMsg(Message other) {
    final DateTime thisTime = timeSent.toDate();
    final DateTime otherTime = other.timeSent.toDate();
    return thisTime.day == otherTime.day &&
        thisTime.month == otherTime.month &&
        thisTime.year == otherTime.year;
  }

  @override
  String toString() {
    return 'Message{messageID: $messageID, timeSent: $timeSent, senderName: $senderName, senderID: $senderID, text: $text, isSharedTrade: $isSharedTrade, isRead: $isRead}';
  }
}
