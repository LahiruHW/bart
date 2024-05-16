import 'package:cloud_firestore/cloud_firestore.dart';

class ChatFirestore {
  ChatFirestore({
    required this.chatID,
    this.chatImageUrl = "",
    this.chatName = "",
    required this.lastMessage,
    required this.lastUpdated,
    required this.users,
    this.unreadMsgCountMap = const {},
  });

  final String chatID;
  final String chatImageUrl;
  final String chatName;
  final String lastMessage;
  final Timestamp lastUpdated;
  final List<String> users;
  Map<String, dynamic> unreadMsgCountMap;

  factory ChatFirestore.fromMap(Map<String, dynamic> map) {
    return ChatFirestore(
      chatID: map['chatID'],
      chatImageUrl: map['chatImageUrl'],
      chatName: map['chatName'],
      lastMessage: map['lastMessage'],
      lastUpdated: map['lastUpdated'],
      users: List<String>.from(map['users']),
      unreadMsgCountMap: map['unreadMsgCountMap'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatImageUrl': chatImageUrl,
      'chatName': chatName,
      'lastMessage': lastMessage,
      'lastUpdated': lastUpdated,
      'users': users,
      'unreadMsgCountMap': unreadMsgCountMap,
    };
  }

}
