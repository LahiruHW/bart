import 'package:flutter/material.dart';
import 'package:bart_app/common/entity/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bart_app/common/widgets/chat_list_tile.dart';
import 'package:bart_app/common/entity/user_local_profile.dart';

class ChatWidgetsExample {

  // static late final BuildContext _context;

  // static void init(BuildContext thisContext) {
  //   _context = thisContext;
  // }

  static final _sampleUser1 = UserLocalProfile(
    userName: "John",
    userID: "123",
  );

  static final _sampleUser2 = UserLocalProfile(
    userName: "Sue",
    userID: "456",
  );

  static final _sampleChat = Chat(
    chatID: "sampleChatID",
    chatName: "John Doe",
    lastMessage: "Hello there!",
    usersIDList: ['123', '456'],
    users: [_sampleUser1, _sampleUser2],
    unreadMsgCountMap: {'123': 0, '456': 0},
    lastUpdated: Timestamp.now(),
  );

  static Widget chatListTileExample() {
    return ChatListTile(
      chat: _sampleChat,
      onTap: () {},
    );
  }
}
