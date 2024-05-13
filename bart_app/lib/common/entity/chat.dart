import 'package:bart_app/common/entity/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  Chat({
    required this.chatID,
    this.chatImageUrl = "",
    this.chatName = "",
    this.lastMessage = "",
    required this.lastUpdated,
    this.users = const [],
    this.usersIDList = const [],
    this.retrigger, // used to retrigger the chat list tile and make it refresh
    this.unreadMsgCount = 0,
  });

  final String chatID;
  final String chatImageUrl;
  final String chatName;
  String lastMessage;
  final Timestamp lastUpdated;
  final DateTime? retrigger;
  int unreadMsgCount;
  final List<String> usersIDList;
  final List<UserLocalProfile> users;

  factory Chat.fromFirestore(ChatFirestore chatFirestore) {
    return Chat(
      chatID: chatFirestore.chatID,
      chatImageUrl: chatFirestore.chatImageUrl,
      chatName: chatFirestore.chatName,
      lastMessage: chatFirestore.lastMessage,
      lastUpdated: chatFirestore.lastUpdated,
      usersIDList: chatFirestore.users,
      unreadMsgCount: chatFirestore.unreadMsgCount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chatImageUrl': chatImageUrl,
      'chatName': chatName,
      'lastMessage': lastMessage,
      'lastUpdated': lastUpdated,
      'users': usersIDList,
      'unreadMsgCount': unreadMsgCount,
    };
  }

  @override
  String toString() {
    return 'Chat{chatID: $chatID, chatImageUrl: $chatImageUrl, chatName: $chatName, unreadMsgCount: $unreadMsgCount, lastMessage: $lastMessage, lastUpdated: $lastUpdated, users: $users}';
  }

}
