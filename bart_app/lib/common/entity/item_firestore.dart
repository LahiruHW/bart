import 'package:cloud_firestore/cloud_firestore.dart';

class ItemFirestore {
  ItemFirestore({
    this.itemID = '',
    required this.itemDescription,
    required this.itemName,
    required this.itemOwner,
    required this.imgs,
    this.preferredInReturn = const [],
    required this.postedOn,
    this.isListedInMarket = true,
    this.isPayment = false,
  });

  final String itemID;
  final String itemName;
  final String itemOwner;
  final String itemDescription;
  final List<String> imgs;
  final List<String>? preferredInReturn;
  final Timestamp postedOn;
  final bool isListedInMarket;
  final bool isPayment;

  factory ItemFirestore.fromMap(Map<String, dynamic> data) {
    return ItemFirestore(
      itemID: data['id'],
      itemName: data['itemName'],
      itemDescription: data['itemDescription'],
      itemOwner: data['itemOwner'],
      imgs: List<String>.from(data['imgs']),
      preferredInReturn: List<String>.from(data['preferredInReturn']),
      postedOn: data['postedOn'],
      isListedInMarket: data['isListedInMarket'],
      isPayment: data['isPayment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'itemOwner': itemOwner,
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
    return 'ItemFirestore: $itemName, posted by: $itemOwner, isPayment: $isPayment, on: $postedOn \nDescription: $itemDescription \nPreferred in return: $preferredInReturn \nImages: $imgs \n';
  }
}
