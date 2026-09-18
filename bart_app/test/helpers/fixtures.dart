import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bart_app/common/entity/item.dart';
import 'package:bart_app/common/entity/trade.dart';
import 'package:bart_app/common/entity/message.dart';
import 'package:bart_app/common/entity/settings.dart';
import 'package:bart_app/common/entity/user_local_profile.dart';
import 'package:bart_app/common/constants/enum_trade_comp_types.dart';

/// A fixed instant so nothing in the suite depends on the wall clock.
final Timestamp kFixedTimestamp = Timestamp.fromDate(
  DateTime.utc(2025, 6, 14, 9, 30),
);

/// Same calendar day as [kFixedTimestamp], different hour — for the
/// `isSameDayAs*` helpers.
final Timestamp kSameDayTimestamp = Timestamp.fromDate(
  DateTime.utc(2025, 6, 14, 21, 5),
);

final Timestamp kNextDayTimestamp = Timestamp.fromDate(
  DateTime.utc(2025, 6, 15, 9, 30),
);

UserSettings buildSettings({
  bool isDarkMode = false,
  bool isLegacyUI = false,
  Timestamp? lastUpdated,
  String? lastUpdatedString,
}) {
  final stamp = lastUpdated ?? kFixedTimestamp;
  return UserSettings(
    isDarkMode: isDarkMode,
    isLegacyUI: isLegacyUI,
    lastUpdated: stamp,
    lastUpdatedString: lastUpdatedString ?? stamp.toDate().toIso8601String(),
  );
}

UserLocalProfile buildUser({
  String userID = 'user-1',
  String userName = 'alice',
  String fullName = 'Alice Anderson',
  bool isFirstLogin = false,
  List<String> chats = const ['chat-1'],
  String? imageUrl = 'https://example.test/alice.png',
  UserSettings? settings,
  String? localeString = 'en',
  String? fcmToken = 'fcm-token-1',
  Timestamp? lastUpdated,
}) {
  return UserLocalProfile(
    userID: userID,
    userName: userName,
    fullName: fullName,
    isFirstLogin: isFirstLogin,
    chats: chats,
    imageUrl: imageUrl,
    settings: settings ?? buildSettings(),
    localeString: localeString,
    fcmToken: fcmToken,
    lastUpdated: lastUpdated ?? kFixedTimestamp,
  );
}

Item buildItem({
  String itemID = 'item-1',
  String itemName = 'Vintage Camera',
  String itemDescription = 'A 35mm film camera in good condition.',
  UserLocalProfile? itemOwner,
  List<String> imgs = const ['https://example.test/cam.png'],
  List<String>? preferredInReturn = const ['books'],
  Timestamp? postedOn,
  bool isListedInMarket = true,
  bool isPayment = false,
}) {
  return Item(
    itemID: itemID,
    itemName: itemName,
    itemDescription: itemDescription,
    itemOwner: itemOwner ?? buildUser(),
    imgs: imgs,
    preferredInReturn: preferredInReturn,
    postedOn: postedOn ?? kFixedTimestamp,
    isListedInMarket: isListedInMarket,
    isPayment: isPayment,
  );
}

/// Builds a trade whose *traded* item belongs to [traderID] (the person who
/// listed the item) and whose *offered* item belongs to [tradeeID] (the person
/// making the offer). That ownership split is what every predicate in
/// `TradeTypeChecker` keys off.
Trade buildTrade({
  String tradeID = 'trade-1',
  String traderID = 'trader-id',
  String tradeeID = 'tradee-id',
  bool isRead = false,
  bool isAccepted = false,
  bool acceptedByTrader = false,
  bool acceptedByTradee = false,
  bool isCompleted = false,
  TradeCompType tradeCompType = TradeCompType.none,
  Timestamp? timeCreated,
  Timestamp? timeUpdated,
}) {
  return Trade(
    tradeID: tradeID,
    tradedItem: buildItem(
      itemID: 'traded-item',
      itemName: 'Traded Item',
      itemOwner: buildUser(userID: traderID, userName: 'trader'),
    ),
    offeredItem: buildItem(
      itemID: 'offered-item',
      itemName: 'Offered Item',
      itemOwner: buildUser(userID: tradeeID, userName: 'tradee'),
    ),
    timeCreated: timeCreated ?? kFixedTimestamp,
    timeUpdated: timeUpdated,
    isRead: isRead,
    isAccepted: isAccepted,
    acceptedByTrader: acceptedByTrader,
    acceptedByTradee: acceptedByTradee,
    isCompleted: isCompleted,
    tradeCompType: tradeCompType,
  );
}

Message buildMessage({
  String messageID = 'msg-1',
  Timestamp? timeSent,
  String senderID = 'user-1',
  String senderName = 'alice',
  String text = 'hello there',
  bool isSharedTrade = false,
  bool isSharedItem = false,
  bool isRead = false,
  Map<String, dynamic> extra = const {},
}) {
  return Message(
    messageID: messageID,
    timeSent: timeSent ?? kFixedTimestamp,
    senderID: senderID,
    senderName: senderName,
    text: text,
    isSharedTrade: isSharedTrade,
    isSharedItem: isSharedItem,
    isRead: isRead,
    extra: extra,
  );
}
