import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:bart_app/common/constants/enum_message_types.dart';

class Message {
  Message({
    this.messageID = "",
    required this.timeSent,
    required this.senderID,
    required this.text,
    required this.isSharedTrade,
    this.isRead = false,
    
    // this.msgType = MessageType.text,
    // this.extra = const {},
  });

  final String messageID;
  final Timestamp timeSent;
  final String senderID;
  final String text;
  final bool isSharedTrade;
  bool? isRead;
  // final MessageType msgType;
  // final Map<String, dynamic> extra;

  factory Message.fromMap(Map<String, dynamic> json) {
    // final thisMsgType = MessageType.fromString(json['msgType']);
    return Message(
      messageID: json['msgID'],
      timeSent: json['timeSent'],
      senderID: json['senderID'],
      text: json['text'],
      isSharedTrade: json['isSharedTrade'],
      isRead: json['isRead'],
      // msgType: thisMsgType,
      // extra: _extraFactory(thisMsgType, json['extra'])
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'timeSent': timeSent,
      'senderID': senderID,
      'text': text,
      'isSharedTrade': isSharedTrade,
      'isRead': isRead,
      // 'msgType': msgType.value,
      // 'extra': _extraToMap(msgType, extra),
    };
  }

  // static Map<String, dynamic> _extraFromMap(MessageType msgType, Map<String, dynamic> extra) {
  //   switch (msgType) {
  //     case MessageType.text:
  //       return {};
  //     case MessageType.sharedItem:
  //       return {
  //         'tradeID': extra['tradeID'],
  //       };
  //     default:
  //       throw Exception('Message.extraFactory: msgType $msgType is invalid or not implemented yet');
  //   }
  // }

  // static Map<String, dynamic> _extraToMap(MessageType msgType, Map<String, dynamic> extra) {
  //   switch (msgType) {
  //     case MessageType.text:
  //       return {};
  //     case MessageType.sharedItem:
  //       return {
  //         'tradeID': extra['tradeID'],
  //       };
  //     default:
  //       throw Exception('Message.extraFactory: msgType $msgType is invalid or not implemented yet');
  //   }
  // }

  @override
  String toString() {
    return 'Message{messageID: $messageID, timeSent: $timeSent, senderID: $senderID, text: $text, isSharedTrade: $isSharedTrade, isRead: $isRead}';
  }

}
