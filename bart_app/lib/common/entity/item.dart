import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bart_app/common/entity/item_firestore.dart';
import 'package:bart_app/common/entity/user_local_profile.dart';

class Item {
  Item({
    this.itemID = '',
    required this.itemDescription,
    required this.itemName,
    required this.itemOwner,
    required this.imgs,
    this.preferredInReturn = const [],
    required this.postedOn,
    this.isListedInMarket = true,
    this.isPayment =
        false, // if it is a payment item --> item name and description will be the amount
    this.isNull = false,
  });

  final String itemID;
  final String itemName;
  final UserLocalProfile itemOwner;
  final String itemDescription;
  final List<String> imgs;
  final List<String>? preferredInReturn;
  final Timestamp postedOn;
  bool isListedInMarket;
  final bool isPayment;
  bool isNull;

  factory Item.fromMap(Map<String, dynamic> data) {
    return Item(
      itemID: data['itemId'],
      itemName: data['itemName'],
      itemDescription: data['itemDescription'],
      itemOwner: UserLocalProfile.fromMap(data['itemOwner']),
      imgs: List<String>.from(data['imgs']),
      preferredInReturn: List<String>.from(data['preferredInReturn']),
      postedOn: data['postedOn'],
      isListedInMarket: data['isListedInMarket'],
      isPayment: data['isPayment'],
    );
  }

  factory Item.fromFirestore(
      ItemFirestore itemFirestore, UserLocalProfile itemOwner) {
    return Item(
      itemID: itemFirestore.itemID,
      itemName: itemFirestore.itemName,
      itemDescription: itemFirestore.itemDescription,
      itemOwner: itemOwner,
      imgs: itemFirestore.imgs,
      preferredInReturn: itemFirestore.preferredInReturn,
      postedOn: itemFirestore.postedOn,
      isListedInMarket: itemFirestore.isListedInMarket,
      isPayment: itemFirestore.isPayment,
    );
  }

  static final Item _invalidObj = Item(
    itemID: "",
    itemName: "",
    itemDescription: "",
    itemOwner: UserLocalProfile(),
    imgs: [],
    preferredInReturn: null,
    postedOn: Timestamp.now(),
    isListedInMarket: false,
    isPayment: false,
    isNull: true,
  );
  factory Item.empty() => _invalidObj;

  Item copyWith({
    String? itemDescription,
    String? itemName,
    UserLocalProfile? itemOwner,
    List<String>? imgs,
    List<String>? preferredInReturn,
    Timestamp? postedOn,
    bool? isListedInMarket,
    bool? isPayment,
  }) {
    return Item(
      itemID: itemID,
      itemName: itemName ?? this.itemName,
      itemOwner: itemOwner ?? this.itemOwner,
      itemDescription: itemDescription ?? this.itemDescription,
      imgs: imgs ?? this.imgs,
      preferredInReturn: preferredInReturn ?? this.preferredInReturn,
      postedOn: postedOn ?? this.postedOn,
      isListedInMarket: isListedInMarket ?? this.isListedInMarket,
      isPayment: isPayment ?? this.isPayment,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'itemOwner': itemOwner.userID,
      'itemDescription': itemDescription,
      'imgs': imgs,
      'preferredInReturn': preferredInReturn,
      'postedOn': postedOn,
      'isListedInMarket': isListedInMarket,
      'isPayment': isPayment,
    };
  }

  bool doesItemContainQuery(String query) {
    return !isPayment &&
        (itemName.toLowerCase().contains(query.toLowerCase()) ||
            itemDescription.toLowerCase().contains(query.toLowerCase()) ||
            itemOwner.userName.toLowerCase().contains(query.toLowerCase()));
  }

  @override
  String toString() {
    return 'Item: $itemName, posted by: ${itemOwner.userName}, isPayment: $isPayment, on: $postedOn \nDescription: $itemDescription \nPreferred in return: $preferredInReturn \nImages: $imgs \n';
  }
}
