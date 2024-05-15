// ignore_for_file: prefer_function_declarations_over_variables

import 'dart:async';

import 'package:bart_app/common/utility/bart_storage_services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:bart_app/common/entity/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bart_app/common/utility/bart_auth.dart';
// import 'package:bart_app/common/typedefs/typedef_home_item.dart';
import 'package:bart_app/common/constants/enum_login_types.dart';

class BartFirestoreServices {
  BartFirestoreServices() {
    _firestore.settings = const Settings(persistenceEnabled: true);
  }

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      String chatID, String msg, Timestamp ts) async {
    await chatDocRef(chatID).update({
      'lastMessage': msg,
      'lastUpdated': ts,
      'unreadMsgCount': FieldValue.increment(1),
    });
  }

  /// send a message to a chat
  static Future<void> sendMessage(
    String chatID,
    String userID,
    String msgText,
  ) async {
    // final timeStamp = Timestamp.now();
    final timeStamp = Timestamp.fromDate(DateTime.now());
    await updateChatLastMessage(chatID, msgText, timeStamp).then((_) {
      final messageData = Message(
        timeSent: timeStamp,
        senderID: userID,
        text: msgText,
        isSharedTrade: false,
        isRead: false,
      );
      chatRoomCollection(chatID).add(messageData.toMap());
    });
  }

  /// update a chatRoom subcollection and the main chat doc
  /// accordingly, when a message is read
  static Future<void> updateReadMessage(
    String chatID,
    Message msg,
    String currentUserID,
  ) async {
    final msgID = msg.messageID;

    if (msg.senderID != currentUserID && msg.isRead == false) {
      msg.isRead = true;

      // get the number of unread messages in the chat
      final chatDoc = (await chatDocRef(chatID).get()).data()!;
      final chat = ChatFirestore.fromMap({'chatID': chatID, ...chatDoc});

      // update the last message in the chatRoom subcollection
      chatRoomCollection(chatID).doc(msgID).update(msg.toMap());

      // update the main chat doc
      chatDocRef(chatID).update({
        'lastUpdated': Timestamp.fromDate(DateTime.now()),
        'unreadMsgCount':
            chat.unreadMsgCount > 1 ? FieldValue.increment(-1) : 0,
      });
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

  /// get the map data needed for a single item
  static Future<Item> getItemData(String itemID) async {
    final mapData = await itemCollection.doc(itemID).get().then((docSnap) {
      var data = {
        'id': itemID,
        ...docSnap.data() as Map<String, dynamic>,
      };
      if (docSnap.exists) {
        return Future<Map<String, dynamic>>.value(data);
      } else {
        return Future<Map<String, dynamic>>.value({});
      }
    });

    // get the owner's profile data for the item
    final ownerID = mapData['itemOwner'];
    final ownerData = await getUserProfileData(ownerID);

    final Map<String, dynamic> itemMap = {
      'itemId': mapData['id'],
      'itemOwnerID': ownerID,
      'itemOwner': ownerData,
      'itemDescription': mapData['itemDescription'],
      'itemName': mapData['itemName'],
      'imgs': List<String>.from(mapData['imgs']),
      'preferredInReturn': List<String>.from(mapData['preferredInReturn']),
      'postedOn': mapData['postedOn'],
    };

    return Future.value(Item.fromMap(itemMap));
  }

  static Future<bool> doesUserNameExist(String newUserName) async {
    return await userCollection.where('userName', isEqualTo: newUserName).get().then((snapshot) {
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

  static Stream<List<Message>> chatRoomMessageListStream(String chatID) {
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
          (chatMap) {
            // // check how many users are in the chat
            final users = List<String>.from(chatMap.users);

            // get a list of the recipients' user profiles using the user id list
            // exclude the current user's profile
            final userProfileList = users
                .map((thisUserID) =>
                    userList.firstWhere((user) => user.userID == thisUserID))
                .where((userProfile) => userProfile.userID != userID)
                .toList();

            if (userProfileList.length == 1) {
              final recipient = userProfileList.first;
              return Chat(
                chatID: chatMap.chatID,
                chatImageUrl: recipient.imageUrl ?? "",
                chatName: recipient.userName,
                lastMessage: chatMap.lastMessage,
                lastUpdated: chatMap.lastUpdated,
                // retrigger: timeNow,
                unreadMsgCount: chatMap.unreadMsgCount,
              );
            }
            // TODO:_ if there are more than one user in the chat, return a group chat
            return Chat(
              chatID: chatMap.chatID,
              chatImageUrl: chatMap.chatImageUrl,
              chatName: 'Group Chat',
              lastMessage: chatMap.lastMessage,
              lastUpdated: chatMap.lastUpdated,
              retrigger: timeNow,
              unreadMsgCount: chatMap.unreadMsgCount,
            );
          },
        ).toList();
      },
    );
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
  static Future<String> createChatRoom(
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
            lastUpdated: Timestamp.now(),
          );

          return await chatDocRef(newChatID).set(newChat.toJson()).then(
            (_) async {
              // add the chat id to the user's chat list
              for (final user in users) {
                user.chats.add(newChatID);
                await userProfileDocRef(user.userID).update({
                  'chats': FieldValue.arrayUnion([newChatID]),
                });
              }
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

  static void addPropertyToCollection(
    CollectionReference collection,
    Map<String, dynamic> data,
  ) {
    collection
        .where(FieldPath.documentId, isNotEqualTo: 'PLACEHOLDER')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.update(data);
      }
    });
  }

  static void updateAllMessages(String chatID) {
    chatRoomCollection(chatID).get().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.update({'isRead': true});
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

  /// nuke a given collection by deleting all the documents in it
  static void nukeCollection(CollectionReference collection) {
    collection.get().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }
}
