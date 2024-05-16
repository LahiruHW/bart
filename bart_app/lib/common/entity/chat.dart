
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bart_app/common/entity/chat_firestore.dart';
import 'package:bart_app/common/entity/user_local_profile.dart';

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
    this.unreadMsgCountMap = const {},
  });

  final String chatID;
  final String chatImageUrl;
  final String chatName;
  String lastMessage;
  Timestamp lastUpdated;
  final DateTime? retrigger;
  Map<String, dynamic> unreadMsgCountMap;
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
      unreadMsgCountMap: chatFirestore.unreadMsgCountMap,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chatImageUrl': chatImageUrl,
      'chatName': chatName,
      'lastMessage': lastMessage,
      'lastUpdated': lastUpdated,
      'users': usersIDList,
      'unreadMsgCountMap': unreadMsgCountMap,
    };
  }

  /// get the total of all the unread messages for all the users except the current user
  int getUnreadMsgCountForUser(String userID) {
    // copy the map to avoid modifying the original
    final newMap = Map<String, dynamic>.from(unreadMsgCountMap);
    newMap.remove(userID);
    return newMap.values.reduce((value, element) => value + element);
  }

  @override
  String toString() {
    return 'Chat{chatID: $chatID, chatImageUrl: $chatImageUrl, chatName: $chatName, unreadMsgCountMap: $unreadMsgCountMap, lastMessage: $lastMessage, lastUpdated: $lastUpdated, users: $users}';
  }
}
