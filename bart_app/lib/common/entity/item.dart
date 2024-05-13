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
    // if isPayment = true, then it is a payment item --> item name and description will be the amount
    this.isPayment = false,
  });

  final String itemID;
  final String itemName;
  final UserLocalProfile itemOwner;
  final String itemDescription;
  final List<String> imgs;
  final List<String>? preferredInReturn;
  final Timestamp postedOn;
  final bool isListedInMarket;
  final bool isPayment;

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

  @override
  String toString() {
    return 'Item: $itemName, posted by: ${itemOwner.userName}, isPayment: $isPayment, on: $postedOn \nDescription: $itemDescription \nPreferred in return: $preferredInReturn \nImages: $imgs \n';
  }
}
