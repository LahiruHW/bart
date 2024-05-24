// ignore_for_file: prefer_function_declarations_over_variables

import 'dart:io';
import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:bart_app/common/entity/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bart_app/common/utility/bart_auth.dart';
// import 'package:bart_app/common/typedefs/typedef_home_item.dart';
import 'package:bart_app/common/constants/enum_login_types.dart';
import 'package:bart_app/common/utility/bart_storage_services.dart';

import 'package:bart_app/common/constants/use_emulators.dart';

class BartFirestoreServices {
  BartFirestoreServices() {
    _firestore = FirebaseFirestore.instance;
    _firestore.settings = const Settings(persistenceEnabled: true);

    if (FirebaseEmulatorService.useEmulators) {
      final host = Platform.isAndroid ? Platform.localHostname : "127.0.0.1";
      _firestore.useFirestoreEmulator(host, 8080);
      debugPrint('------------------- using Firestore Emulator at: $host:8080');
    }
  }

  static late final FirebaseFirestore _firestore;

  static final userCollection = _firestore.collection('user_profile');
  static final userProfileDocRef = (userId) => userCollection.doc(userId);

  static final chatCollection = _firestore.collection('chat');
  static final chatDocRef = (chatId) => chatCollection.doc(chatId);

  static final chatRoomCollection =
      (chatId) => chatDocRef(chatId).collection('chatRoom');

  static final itemCollection = _firestore.collection('item');

  static final tradeCollection = _firestore.collection('trade');

  static final requestCollection = _firestore.collection('request');

  // static final _transformer1 =
  //     StreamTransformer<List<HomeItem>, List<Trade>>.fromHandlers(
  //   handleData: (homeItemList, sink) {
  //     final tempList = <Trade>[];
  //     for (final item in homeItemList) {
  //       if (item is Trade) {
  //         tempList.add(item);
  //       }
  //     }
  //     sink.add(tempList);
  //   },
  // );

  // /////////////////////////////////////////////////////////////////////////////////////////////
  // /////////////////////////////////////////////////////////////////////////////////////////////
  // /////////////////////////////////////////////////////////////////////////////////////////////
  // /////////////////////////////////////////////////////////////////////////////////////////////

  /// initialize user profile - username can be null for a firstime google login
  static Future<Map<String, dynamic>> setupUserProfile(
      String userID, String? userName, String? imageUrl,
      {LoginType? loginType}) async {
    // only initialize the user profile if it doesn't exist - needed for google login
    final userProfile = await userProfileDocRef(userID).get();

    Map<String, dynamic> returnMap = {
      'userProfile': null,
      'currentChat': null,
      'savedChats': null,
    };

    if (userProfile.exists) {
      debugPrint("--------------- PROFILE ALREADY EXISTS IN FIREBASE");

      final UserLocalProfile userProfile =
          await getUserProfileData(userID).then((userProfileData) {
        final userProfile = UserLocalProfile.fromMap(userProfileData);
        debugPrint("--------------- LOCAL PROFILE: $userProfile");
        return userProfile;
      });

      userProfile.isFirstLogin = false;

      returnMap['userProfile'] = userProfile;

      return returnMap;
    } else {
      // if the new login type is google, generate a random name
      if (loginType == LoginType.google) {
        final newUserName = BartAuthService.getRandomName();
        debugPrint("--------------- GOOGLE LOGIN");
        return initializeNewUserProfile(userID, newUserName, imageUrl!);
      }
      return initializeNewUserProfile(userID, userName, imageUrl!);
    }
  }

  /// initialize a new user's profile data
  static Future<Map<String, dynamic>> initializeNewUserProfile(
    String userID,
    String? userName,
    String? imageUrl,
  ) async {
    final newSettings = UserSettings();
    final userProfile = UserLocalProfile(
      userID: userID,
      imageUrl: imageUrl!,
      isFirstLogin: true,
      userName: userName ?? '',
      settings: newSettings,
    );

    Map<String, dynamic> returnMap = {
      'userProfile': userProfile,
    };

    await userProfileDocRef(userID).set(userProfile.toMap());

    return returnMap;
  }

  /// get a Future of the user's cloud firestore profile data
  static Future<Map<String, dynamic>> getUserProfileData(String userID) {
    // if docs with the userID as the docID exists,
    // return the data as a Map<String, dynamic>
    return userProfileDocRef(userID).get().then((docSnap) {
      var data = {
        'userID': userID,
        ...docSnap.data() as Map<String, dynamic>,
      };
      if (docSnap.exists) {
        return Future<Map<String, dynamic>>.value(
            data); // extend here to get the user's id
      } else {
        return Future<Map<String, dynamic>>.value({});
      }
    });
  }

  static Future<void> updateChatLastMessage(
      String chatID, String userID, String msg, Timestamp ts) async {
    final unreadMsgCountMap = (await chatDocRef(chatID).get())
        .data()!['unreadMsgCountMap'] as Map<String, dynamic>;
    final userVal = unreadMsgCountMap[userID] as int;
    unreadMsgCountMap.remove(userID);

    await chatDocRef(chatID).update({
      'lastMessage': msg,
      'lastUpdated': ts,
      'unreadMsgCountMap': {
        userID: userVal + 1,
        ...unreadMsgCountMap,
      },
    });
  }

  static Future<void> updateChatLastMessageUsingChatObj(
    Chat chat,
    String userID,
    String msg,
    Timestamp ts,
  ) async {
    // if unreadMsgCountMap is null, set it to an empty map using the userIDS
    if (chat.unreadMsgCountMap.isEmpty) {
      chat.unreadMsgCountMap = {};
      for (final user in chat.users) {
        chat.unreadMsgCountMap[user.userID] = 0;
      }
    }
    final userVal = chat.unreadMsgCountMap[userID] as int;
    chat.lastUpdated = ts;
    chat.lastMessage = msg;
    chat.unreadMsgCountMap[userID] = userVal + 1;
    await chatDocRef(chat.chatID).update(chat.toMap());
  }

  /// send a message to a chat
  static Future<void> sendMessageUsingChatID(
    String chatID,
    String userID,
    String msgText, {
    bool isSharedTrade = false,
    bool isSharedItem = false,
    Trade? tradeContent,
    Item? itemContent,
  }) async {
    final timeStamp = Timestamp.fromDate(DateTime.now());
    await updateChatLastMessage(chatID, userID, msgText, timeStamp).then((_) {
      final messageData = Message(
        timeSent: timeStamp,
        senderID: userID,
        text: msgText,
        isSharedTrade: isSharedTrade,
        isSharedItem: isSharedItem,
        isRead: false,
        extra: {
          'tradeContent': tradeContent,
          'itemContent': itemContent,
        },
      );
      chatRoomCollection(chatID).add(messageData.toMap());
    });
  }

  static Future<void> sendMessageUsingChatObj(
    Chat chat,
    String userID,
    String msgText,
  ) async {
    final timeStamp = Timestamp.fromDate(DateTime.now());
    await updateChatLastMessageUsingChatObj(chat, userID, msgText, timeStamp)
        .then((_) {
      final messageData = Message(
        timeSent: timeStamp,
        senderID: userID,
        text: msgText,
        isSharedTrade: false,
        isRead: false,
      );
      chatRoomCollection(chat.chatID).add(messageData.toMap());
    });
  }

  static Future<void> updateReadMessage(
    Chat chat,
    Message msg,
    String currentUserID,
  ) async {
    final msgID = msg.messageID;
    final senderID = msg.senderID;

    // only update a message as read if the message is unread and the sender is not the current user
    if (senderID != currentUserID && msg.isRead == false) {
      msg.isRead = true;
      // reduce the unread message count for the sender
      final userVal = chat.unreadMsgCountMap[senderID] as int;

      chat.unreadMsgCountMap[senderID] = (userVal > 1) ? userVal - 1 : 0;
      // chat.lastUpdated = Timestamp.fromDate(DateTime.now());
      await chatDocRef(chat.chatID).update(chat.toMap());
      await chatRoomCollection(chat.chatID).doc(msgID).update(msg.toMap());
    }
  }

  static String getNextNewItemID() {
    return itemCollection.doc().id;
  }

  /// add a new item to the item collection
  static Future<void> addItem(Item item, String docID) async {
    final itemData = item.toJson();
    await itemCollection.doc(docID).set(itemData);
  }

  /// update a single item
  static Future<void> updateItem(Item item) async {
    await itemCollection.doc(item.itemID).update(item.toJson());
  }

  static Future<bool> doesUserNameExist(String newUserName) async {
    return await userCollection
        .where('userName', isEqualTo: newUserName)
        .get()
        .then((snapshot) {
      return snapshot.docs.isNotEmpty;
    });
  }

  /// update the user's profile
  static Future<void> updateUserProfile(UserLocalProfile newProfile) async {
    await userProfileDocRef(newProfile.userID).update(newProfile.toMap());
  }

  static Future<void> updateUserProfileSettings(
    String userID,
    UserSettings newSettings,
  ) async {
    userProfileDocRef(userID).update(
      // not using await here to trigger the update in a fire and forget manner
      {'settings': newSettings.toMap()},
    );
  }

  static Future<UserLocalProfile> getUserProfile(String userID) async {
    // return getCurrentUserProfileStream(userID).first;
    return userProfileDocRef(userID).get().then((docSnap) {
      final data = {
        'userID': docSnap.id,
        ...docSnap.data() as Map<String, dynamic>
      };
      return UserLocalProfile.fromMap(data);
    });
  }

  // //////////////////////////////////////////////////////////////////////////////////////////////
  // //////////////////////////////////////////////////////////////////////////////////////////////
  // //////////////////////////////////////////////////////////////////////////////////////////////
  // USER PROFILE STREAMS

  /// stream that listens to all user's profile data
  static Stream<List<UserLocalProfile>> _userProfileCollectionListStream() {
    return userCollection
        .where(FieldPath.documentId, isNotEqualTo: 'PLACEHOLDER')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map(
            (doc) {
              final userData = {'userID': doc.id, ...doc.data()};
              return UserLocalProfile.fromMap(userData);
            },
          ).toList(),
        );
  }

  /// stream the current user's profile data
  static Stream<UserLocalProfile> getCurrentUserProfileStream(String userID) {
    return _userProfileCollectionListStream()
        .where((profileList) =>
            profileList.where((profile) => profile.userID == userID).isNotEmpty)
        .map((profileList) => profileList.first);
  }

  // //////////////////////////////////////////////////////////////////////////////////////////////
  // //////////////////////////////////////////////////////////////////////////////////////////////
  // //////////////////////////////////////////////////////////////////////////////////////////////
  // CHAT STREAMS

  /// get the chat collection stream for, based on one user id
  static Stream<List<ChatFirestore>> _chatCollectionListForOneUserStream(
    String userID,
  ) {
    // where the user id is not PLACEHOLDER
    return chatCollection
        .where(FieldPath.documentId, isNotEqualTo: 'PLACEHOLDER')
        // .orderBy('lastUpdated', descending: true)
        .where(
          'users',
          arrayContains: userID,
        ) // only get chats where the user is a part of the chat
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map(
            (doc) {
              final data = {'chatID': doc.id, ...doc.data()};
              return ChatFirestore.fromMap(data);
            },
          ).toList(),
        )
        .asBroadcastStream();
  }

  static Stream<List<Message>> _chatRoomMessageListStream(String chatID) {
    return chatRoomCollection(chatID)
        .where(FieldPath.documentId, isNotEqualTo: 'PLACEHOLDER')
        .orderBy('timeSent', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final messageData = {'msgID': doc.id, ...doc.data()};
            return Message.fromMap(messageData);
          }).toList(),
        )
        .asBroadcastStream();
  }

  static Stream<List<Message>> chatRoomMessageListStream(
    String chatID,
    String userID,
  ) {
    return Rx.combineLatest4(
      _chatRoomMessageListStream(chatID),
      getItemListStream(),
      getTradeListStream(userID),
      _userProfileCollectionListStream(),
      (msgList, itemList, tradeList, userList) {
        return msgList.map((msg) {
          final userProfile = userList.firstWhere(
            (user) => user.userID == msg.senderID,
          );
          if (msg.isSharedItem!) {
            final String itemID = msg.extra['itemContent'];
            final itemContent =
                itemList.firstWhere((item) => item.itemID == itemID);
            msg.extra['itemContent'] = itemContent;
          }
          if (msg.isSharedTrade!) {
            final String tradeID = msg.extra['tradeContent'];
            final tradeContent =
                tradeList.firstWhere((trade) => trade.tradeID == tradeID);
            msg.extra['tradeContent'] = tradeContent;
          }
          msg.senderName = userProfile.userName;
          return msg;
        }).toList();
      },
    );
  }

  static Stream<DateTime> _streamRebuildTrigger() {
    return Stream.periodic(
      const Duration(seconds: 2),
      (x) => x,
    ).map(
      (x) => DateTime.now(),
    );
  }

  /// combine the user profile stream with the chat collection stream to get the chat object
  static Stream<List<Chat>> getChatListTileStream(String userID) {
    return Rx.combineLatest3(
      // return Rx.combineLatest2(
      _chatCollectionListForOneUserStream(userID),
      _userProfileCollectionListStream(),
      _streamRebuildTrigger(),
      (chatList, userList, timeNow) {
        // (chatList, userList) {
        return chatList.map(
          (chatFirestore) {
            // // check how many users are in the chat
            final users = List<String>.from(chatFirestore.users);

            // get a list of the recipients' user profiles using the user id list
            // exclude the current user's profile
            final userProfileList1 = users
                .map((thisUserID) =>
                    userList.firstWhere((user) => user.userID == thisUserID))
                .toList();
            final userProfileList2 = userProfileList1
                .where((userProfile) => userProfile.userID != userID)
                .toList();

            if (userProfileList2.length == 1) {
              final recipient = userProfileList2.first;
              return Chat(
                chatID: chatFirestore.chatID,
                chatImageUrl: recipient.imageUrl ?? "",
                chatName: recipient.userName,
                lastMessage: chatFirestore.lastMessage,
                lastUpdated: chatFirestore.lastUpdated,
                usersIDList: chatFirestore.users,
                users: userProfileList1,
                unreadMsgCountMap: chatFirestore.unreadMsgCountMap,
                retrigger: timeNow,
              );
            }
            // TODO:_ if there are more than one user in the chat, return a group chat
            return Chat(
              chatID: chatFirestore.chatID,
              chatImageUrl: chatFirestore.chatImageUrl,
              chatName: 'Group Chat',
              lastMessage: chatFirestore.lastMessage,
              lastUpdated: chatFirestore.lastUpdated,
              users: userProfileList1,
              unreadMsgCountMap: chatFirestore.unreadMsgCountMap,
              retrigger: timeNow,
            );
          },
        ).toList();
      },
    ).asBroadcastStream();
  }

  /// check if a chat exist between a number of users,
  /// and returns the chat id if it exists, else returns an empty string
  static Future<String> doesChatExist(List<UserLocalProfile> users) async {
    // for each user, get a list of chat ids they are part of, and then get the intersection of all the lists
    final Set<String> x = users[0].chats.toSet();
    for (int i = 1; i < users.length; i++) {
      final Set<String> y = users[i].chats.toSet();
      x.retainAll(y);
    }
    return x.isEmpty ? '' : x.first;
  }

  /// get a document id for a new document in the chat collection
  static String getNextNewChatID() {
    return chatCollection.doc().id;
  }

  /// create a new chat room
  static Future<String> getChatRoomID(
    UserLocalProfile sender,
    UserLocalProfile receiver,
  ) async {
    List<UserLocalProfile> users = [sender, receiver];

    return doesChatExist(users).then(
      (potentialChatID) async {
        if (potentialChatID.isEmpty) {
          debugPrint(
              '====================== CHAT DOES NOT EXIST, CREATING NEW CHAT');
          final newChatID = getNextNewChatID();
          final newChat = ChatFirestore(
            chatID: newChatID,
            chatImageUrl: receiver.imageUrl ?? "",
            chatName: receiver.userName,
            lastMessage: '',
            users: users.map((user) => user.userID).toList(),
            unreadMsgCountMap: {
              sender.userID: 0,
              receiver.userID: 0,
            },
            lastUpdated: Timestamp.now(),
          );

          return await chatDocRef(newChatID).set(newChat.toJson()).then(
            (_) async {
              // add the chat id to the user's chat list
              for (final user in users) {
                user.chats.add(newChatID);
                await userProfileDocRef(user.userID).update({
                  'chats': FieldValue.arrayUnion([newChatID]),
                  'lastUpdated': Timestamp.now(),
                }).then((_) {
                  debugPrint(
                      '====================== ADDED CHAT ID TO USER PROFILE ${user.userID}');
                });
              }
              await chatRoomCollection(newChatID).doc("PLACEHOLDER").set({
                'alert': null,
              }).then((_) {
                debugPrint(
                    '====================== CHATROOM CREATED, RETURNING CHAT ID');
              });
              return newChatID;
            },
          );
        } else {
          debugPrint('====================== CHAT EXISTS, RETURNING CHAT ID');
          // return the chat id of the existing chat
          return potentialChatID;
        }
        // throw Exception('Chat creation failed');
      },
    );
  }

  /// get the chat object using the chat id
  static Future<Chat> getChat(String userID, String chatID) async {
    // use the stream functions above to get the chat object
    return getChatListTileStream(userID).map(
      (chatList) {
        return chatList.firstWhere((chat) => chat.chatID == chatID);
      },
    ).first;
  }

  // //////////////////////////////////////////////////////////////////////////////////////////////
  // //////////////////////////////////////////////////////////////////////////////////////////////
  // //////////////////////////////////////////////////////////////////////////////////////////////
  // MARKETPLACE STREAMS

  /// get item stream
  static Stream<List<ItemFirestore>> _itemCollectionListStream() {
    return itemCollection
        .where(FieldPath.documentId, isNotEqualTo: 'PLACEHOLDER')
        .orderBy('postedOn', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map(
            (doc) {
              final itemData = {'id': doc.id, ...doc.data()};
              return ItemFirestore.fromMap(itemData);
            },
          ).toList(),
        );
  }

  /// get the stream of items that are in the item collection
  static Stream<List<Item>> getItemListStream() {
    return Rx.combineLatest2(
      _userProfileCollectionListStream(),
      _itemCollectionListStream(),
      (userList, itemList) {
        return itemList.map(
          (item) {
            final owner = userList.firstWhere(
              (user) => user.userID == item.itemOwner,
            );
            return Item.fromFirestore(item, owner);
          },
        ).toList();
      },
    ).asBroadcastStream();
  }

  static Stream<List<Item>> getMarketplaceItemListStream() {
    return getItemListStream().map(
      (itemList) => itemList.where((item) => item.isListedInMarket).toList(),
    );
  }

  // //////////////////////////////////////////////////////////////////////////////////////////////
  // //////////////////////////////////////////////////////////////////////////////////////////////
  // //////////////////////////////////////////////////////////////////////////////////////////////
  // TRADE STREAMS

  static Stream<List<TradeFirestore>> _tradeCollectionListStream() {
    return tradeCollection
        .where(FieldPath.documentId, isNotEqualTo: 'PLACEHOLDER')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map(
            (doc) {
              final tradeData = {'tradeID': doc.id, ...doc.data()};
              return TradeFirestore.fromMap(tradeData);
            },
          ).toList(),
        );
  }

  static Stream<List<Trade>> getTradeListStream(String userID) {
    return Rx.combineLatest2(
      _tradeCollectionListStream(),
      getItemListStream(),
      (tradeList, itemList) {
        return tradeList
            .map(
              (tradeFirestore) {
                final tradedItem = itemList.firstWhere(
                  (item) => item.itemID == tradeFirestore.tradedItem,
                );
                final offeredItem = itemList.firstWhere(
                  (item) => item.itemID == tradeFirestore.offeredItem,
                );
                return Trade.fromFirestore(
                    tradeFirestore, tradedItem, offeredItem);
              },
            )
            // only get a list of trades where the current
            // user is either the trader or the tradee
            .where(
              (thisTrade) =>
                  thisTrade.tradedItem.itemOwner.userID == userID ||
                  thisTrade.offeredItem.itemOwner.userID == userID,
            )
            .toList();
      },
    ).asBroadcastStream();
  }

  /// get the stream of trades where the current user is the owner of the traded item
  static Stream<List<Trade>> getIncomingTradeListStream(String userID) {
    return getTradeListStream(userID)
        // .transform(_transformer1)
        .map((tradeList) {
      return tradeList
          .where(
            (trade) =>
                (!trade.isAccepted) &&
                (!trade.isCompleted) &&
                (!trade.acceptedByTradee &&
                    !trade.acceptedByTrader) && ////////////////
                (trade.tradedItem.itemOwner.userID == userID),
          )
          .toList();
    });
  }

  /// get the stream of trades where the current user is the owner of the offered item
  static Stream<List<Trade>> getOutgoingTradeListStream(String userID) {
    return getTradeListStream(userID)
        // .transform(_transformer1)
        .map((tradeList) {
      return tradeList
          .where(
            (trade) =>
                (!trade.isCompleted) &&
                (!trade.isAccepted) &&
                (!trade.acceptedByTradee &&
                    !trade.acceptedByTrader) && ////////////////
                (trade.offeredItem.itemOwner.userID == userID),
          )
          .toList();
    });
  }

  /// get the stream of trades pertaining to a user, that are successful
  static Stream<List<Trade>> getSuccessfulTradeListStream(String userID) {
    return getTradeListStream(userID)
        // .transform(_transformer1)
        .map((tradeList) {
      return tradeList
          .where(
            (trade) =>
                (!trade.isCompleted) &&
                (trade.isAccepted) &&
                (!trade.acceptedByTrader ||
                    !trade.acceptedByTradee) && ////////////////////
                (trade.tradedItem.itemOwner.userID == userID ||
                    trade.offeredItem.itemOwner.userID == userID),
          )
          .toList();
    });
  }

  /// zip all three main trade streams (incoming, completed, successful) into one
  static Stream<List<List<Trade>>> getTradeListStreamZip(
    String userID,
  ) {
    return Rx.combineLatest3(
      getIncomingTradeListStream(userID),
      getOutgoingTradeListStream(userID),
      getSuccessfulTradeListStream(userID),
      (incomingList, outgoingList, successList) {
        return [
          incomingList,
          outgoingList,
          successList,
        ];
      },
    );
  }

  /// get the stream of trades that are completed (i.e. trade history)
  static Stream<List<Trade>> getCompletedTradeListStream(String userID) {
    return getTradeListStream(userID).map(
      (tradeList) => tradeList
          .where(
            // (trade) => trade.isCompleted,
            // (trade) => trade.acceptedByTrader && trade.acceptedByTradee,
            (trade) =>
                trade.isCompleted ||
                (trade.acceptedByTrader && trade.acceptedByTradee),
          )
          .toList(),
    );
  }

  /// get the next id for a new document in the trade collection
  static String getNextNewTradeID() {
    return tradeCollection.doc().id;
  }

  /// add a new trade to the trade collection
  static Future<void> addTrade(Trade newTrade) async {
    await tradeCollection.add(newTrade.toMap());
  }

  /// update a trade in the trade collection
  static Future<void> updateTrade(Trade trade) async {
    await tradeCollection.doc(trade.tradeID).update(trade.toMap());
  }

  static Future<void> acceptTradeAsTrader(String tradeID) async {
    await tradeCollection.doc(tradeID).update({
      'acceptedByTrader': true,
    });
  }

  static Future<void> acceptTradeAsTradee(String tradeID) async {
    await tradeCollection.doc(tradeID).update({
      'acceptedByTradee': true,
    });
  }

  /// cancel a trade
  static Future<bool> cancelTrade(Trade trade) async {
    // delete all the images of the offered from the storage
    return await BartFirebaseStorageServices.deleteAllItemImages(
      trade.offeredItem.itemID,
    ).then(
      (_) async {
        debugPrint("1. ||||||||||||||||||||| DELETED ALL IMAGES FROM STORAGE");
        // delete the offered item from the item collection
        return await itemCollection.doc(trade.offeredItem.itemID).delete().then(
          (_) async {
            debugPrint("2. |||||||||||||| DELETED OFFERED ITEM FROM FIRESTORE");
            // delete the trade from the trade collection
            return await tradeCollection.doc(trade.tradeID).delete().then(
              (value) {
                debugPrint("3. ||||||||||||||||| DELETED TRADE FROM FIRESTORE");
                return true;
              },
            ).onError((error, stackTrace) {
              debugPrint("3. ||||||||||||||||| ERROR DELETING TRADE: $error");
              return false;
            });
          },
        ).onError((error, stackTrace) {
          debugPrint("2. |||||||||||||| ERROR DELETING OFFERED ITEM: $error");
          return false;
        });
      },
    ).onError((error, stackTrace) {
      debugPrint("1. ||||||||||||||||||||| ERROR DELETING IMAGES: $error");
      return false;
    });
  }

  // //////////////////////////////////////////////////////////////////////////////////////////////
  // //////////////////////////////////////////////////////////////////////////////////////////////
  // //////////////////////////////////////////////////////////////////////////////////////////////
  // REQUEST STREAMS

  static Stream<List<RequestFirestore>> _requestCollectionListStream() {
    return requestCollection
        .where(FieldPath.documentId, isNotEqualTo: 'PLACEHOLDER')
        .snapshots()
        .map(
          (event) => event.docs.map(
            (requestMap) {
              final data = {'id': requestMap.id, ...requestMap.data()};

              return RequestFirestore.fromMap(data);
            },
          ).toList(),
        );
  }

  // the above stream of requests must be combined with the user profile stream to get the user's profile data

  // //////////////////////////////////////////////////////////////////////////////////////////////
  // //////////////////////////////////////////////////////////////////////////////////////////////
  // //////////////////////////////////////////////////////////////////////////////////////////////
  // UTILITY FUNCTIONS

  /// update the document structure of the item collection
  static void updateItemSchema() async {
    final itemIDList = await itemCollection.get().then((snapshot) {
      return snapshot.docs
          .where((doc) => doc.id != "PLACEHOLDER")
          .map((doc) => doc.id)
          .toList();
    });
    debugPrint("$itemIDList");
    for (final itemID in itemIDList) {
      itemCollection.doc(itemID).get().then((doc) async {
        final itemData = doc.data() as Map<String, dynamic>;
        final updatedDoc = Map<String, dynamic>.from(itemData);

        if (!itemData.containsKey('imgs')) {
          updatedDoc['imgs'] = FieldValue.arrayUnion([]);
          debugPrint("missing 'imgs' added to item $itemID");
        }
        if (!itemData.containsKey('isListedInMarket')) {
          updatedDoc['isListedInMarket'] = true;
          debugPrint("missing 'isListedInMarket' added to item $itemID");
        }
        if (!itemData.containsKey('isPayment')) {
          updatedDoc['isPayment'] = false;
          debugPrint("missing 'isTradeable' added to item $itemID");
        }
        if (!itemData.containsKey('itemDescription')) {
          updatedDoc['itemDescription'] = '';
          debugPrint("missing 'itemDescription' added to item $itemID");
        }
        if (!itemData.containsKey('itemName')) {
          updatedDoc['itemName'] = '';
          debugPrint("missing 'itemName' added to item $itemID");
        }
        // 'itemOwner' is added at item creation
        // 'postedOn' is added at item creation
        if (!itemData.containsKey('preferredInReturn')) {
          updatedDoc['preferredInReturn'] = FieldValue.arrayUnion([]);
          debugPrint("missing 'preferredInReturn' added to item $itemID");
        }
        await doc.reference.update(updatedDoc);
      });
    }
  }

  /// update the document structure of all the chatRoom collections
  static void updateMessagesSchema() async {
    final chatIDList = await chatCollection.get().then((snapshot) {
      return snapshot.docs
          .where((doc) => doc.id != "PLACEHOLDER")
          .map((doc) => doc.id)
          .toList();
    });
    debugPrint("$chatIDList");
    for (final chatID in chatIDList) {
      chatRoomCollection(chatID).get().then((snapshot) async {
        for (DocumentSnapshot doc in snapshot.docs) {
          if (doc.id == 'PLACEHOLDER') {
            continue;
          }
          final messageData = doc.data() as Map<String, dynamic>;
          final updatedDoc = Map<String, dynamic>.from(messageData);
          if (!messageData.containsKey('extra')) {
            updatedDoc['extra'] = {};
            debugPrint("missing 'extra' added to message $chatID/${doc.id}");
          }
          if (!messageData.containsKey('isRead')) {
            updatedDoc['isRead'] = false;
            debugPrint("missing 'isRead' added to message $chatID/${doc.id}");
          }
          if (!messageData.containsKey('isSharedItem')) {
            updatedDoc['isSharedItem'] = false;
            debugPrint(
                "missing 'isSharedItem' added to message $chatID/${doc.id}");
          }
          if (!messageData.containsKey('isSharedTrade')) {
            updatedDoc['isSharedTrade'] = false;
            debugPrint(
                "missing 'isSharedTrade' added to message $chatID/${doc.id}");
          }
          // "senderID" is added at sendinng time
          if (!messageData.containsKey('senderName')) {
            updatedDoc['senderName'] = '';
            debugPrint(
                "missing 'senderName' added to message $chatID/${doc.id}");
          }
          // "text" is attached at sending time
          // "timeSent" is attached at sending time
          await doc.reference.update(updatedDoc); // finally update the doc
        }
      });
    }
  }

  /// delete a trade if any involved items in the trade does not exist
  static void cleanupTradesBasedOnItems() async {
    tradeCollection.get().then((snapshot) async {
      for (DocumentSnapshot doc in snapshot.docs) {
        if (doc.id == 'PLACEHOLDER') {
          continue;
        }
        final tradeData = doc.data() as Map<String, dynamic>;
        final tradedItemID = tradeData['tradedItem'] as String;
        final offeredItemID = tradeData['offeredItem'] as String;

        final bool bool1 =
            await itemCollection.doc(tradedItemID).get().then((value) {
          return value.exists;
        });
        final bool bool2 =
            await itemCollection.doc(offeredItemID).get().then((value) {
          return value.exists;
        });

        if (!bool1 || !bool2) {
          doc.reference.delete();
        }
      }
    });
  }

  static void cancelEntireTradeCollection() async {
    // remove all documents from the trade collection
    await tradeCollection.get().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });

    // remove all documents from the item collection where the item is not listed in the marketplace
    itemCollection.get().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        final itemData = doc.data() as Map<String, dynamic>;
        if (!itemData['isListedInMarket']) {
          doc.reference.delete();
        }
      }
    });
  }

  // remove any document from the itemCollection that has the value 'We don't have that much time left' for the key 'itemDescription'
  static void removeItemWithProperty(
      CollectionReference collection, String key, String value) {
    collection.get().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        final x = doc.data() as Map<String, dynamic>;
        if (x[key] == value) {
          doc.reference.delete();
        }
      }
    });
  }

  // remove any document from a collection that doesn't have any of a list of document ids
  static void removeDocUsingIDs(
      CollectionReference collection, List<String> docIDs) {
    collection.get().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        if (!docIDs.contains(doc.id)) {
          doc.reference.delete();
        }
      }
    });
  }

  /// cleanup unused images in the storage folder
  static void cleanupStorageImages() async {

    // get all the item ids from the storage folder
    await BartFirebaseStorageServices.itemFolderRef.listAll().then((result) {
      final List<String> storageItemIDs = result.prefixes.map((item) {
        final itemID = item.fullPath.split('/')[1];
        return itemID;
      }).toList();

      print(storageItemIDs);

      // get all the item ids from the item collection
      itemCollection.get().then((snapshot) {
        final firestoreItemIDs = snapshot.docs.map((doc) {
          return doc.id;
        }).toList();

        // if the item id from the storage folder is not in the item collection, delete all the images in the folder
        for (final storageItemID in storageItemIDs) {
          if (!firestoreItemIDs.contains(storageItemID)) {
            BartFirebaseStorageServices.deleteAllItemImages(storageItemID);
            print("Deleting images for item: $storageItemID");
          }
        }
      });
    });

    // final x = await BartFirebaseStorageServices.storage.ref("item").listAll();
    // print(x);
    // print(x.items);
    // print(x.prefixes);

  }

  /// nuke a given collection by deleting all the documents in it
  static void nukeCollection(CollectionReference collection) {
    collection.get().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }
}
