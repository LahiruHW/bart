import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bart_app/common/entity/item.dart';

import '../../helpers/fixtures.dart';

Map<String, dynamic> _firestoreMap({
  Map<String, dynamic> overrides = const {},
}) {
  return {
    'itemId': 'item-42',
    'itemName': 'Acoustic Guitar',
    'itemDescription': 'Six string, barely played.',
    'itemOwner': {
      'userID': 'owner-1',
      'userName': 'erin',
      'fullName': 'Erin Evans',
      'chats': <String>[],
      'isFirstLogin': false,
      'imageUrl': null,
      'settings': {
        'isDarkMode': false,
        'isLegacyUI': false,
        'lastUpdated': kFixedTimestamp,
        'lastUpdatedString': kFixedTimestamp.toDate().toIso8601String(),
      },
      'localeString': 'en',
      'lastUpdated': kFixedTimestamp,
      'fcmToken': 'token-1',
    },
    'imgs': ['https://example.test/guitar.png'],
    'preferredInReturn': ['amplifier'],
    'postedOn': kFixedTimestamp,
    'isListedInMarket': true,
    'isPayment': false,
    ...overrides,
  };
}

void main() {
  group('Item.fromMap', () {
    test('reads the Firestore document, including the nested owner', () {
      final item = Item.fromMap(_firestoreMap());

      expect(item.itemID, 'item-42');
      expect(item.itemName, 'Acoustic Guitar');
      expect(item.itemDescription, 'Six string, barely played.');
      expect(item.imgs, ['https://example.test/guitar.png']);
      expect(item.preferredInReturn, ['amplifier']);
      expect(item.postedOn, kFixedTimestamp);
      expect(item.isListedInMarket, isTrue);
      expect(item.isPayment, isFalse);
      expect(item.itemOwner.userID, 'owner-1');
      expect(item.itemOwner.userName, 'erin');
    });

    test('reads the id from "itemId", not "itemID"', () {
      // The Firestore field is camel-cased differently from the Dart property.
      // Pinned because a rename on either side silently yields a null id.
      final item = Item.fromMap(_firestoreMap());

      expect(item.itemID, isNotEmpty);
    });

    test('defaults imgFiles to empty, since XFiles are never persisted', () {
      final item = Item.fromMap(_firestoreMap());

      expect(item.imgFiles, isEmpty);
    });

    test('throws when preferredInReturn is absent', () {
      // List<String>.from(null) is not tolerated, unlike the chats field on
      // UserLocalProfile. Documented so callers know the field is required.
      expect(
        () =>
            Item.fromMap(_firestoreMap(overrides: {'preferredInReturn': null})),
        throwsA(isA<TypeError>()),
      );
    });
  });

  group('Item.empty', () {
    test('is flagged as null and carries no content', () {
      final empty = Item.empty();

      expect(empty.isNull, isTrue);
      expect(empty.itemID, isEmpty);
      expect(empty.itemName, isEmpty);
      expect(empty.itemDescription, isEmpty);
      expect(empty.imgs, isEmpty);
      expect(empty.preferredInReturn, isNull);
      expect(empty.isListedInMarket, isFalse);
    });

    test('hands back one shared instance, not a fresh copy per call', () {
      // isListedInMarket and isNull are mutable on a static final instance, so
      // writing to Item.empty() changes the placeholder process-wide.
      expect(identical(Item.empty(), Item.empty()), isTrue);
    });
  });

  group('Item.copyWith', () {
    test('overrides only the fields it is given', () {
      final original = buildItem(
        itemName: 'Old Name',
        itemDescription: 'Old description',
        isListedInMarket: true,
      );

      final updated = original.copyWith(itemName: 'New Name');

      expect(updated.itemName, 'New Name');
      expect(updated.itemDescription, 'Old description');
      expect(updated.imgs, original.imgs);
      expect(updated.preferredInReturn, original.preferredInReturn);
      expect(updated.postedOn, original.postedOn);
      expect(updated.isListedInMarket, isTrue);
    });

    test('carries the itemID across, since it cannot be overridden', () {
      final original = buildItem(itemID: 'item-keepme');

      expect(original.copyWith(itemName: 'anything').itemID, 'item-keepme');
    });

    test('can delist an item from the market', () {
      final delisted = buildItem(
        isListedInMarket: true,
      ).copyWith(isListedInMarket: false);

      expect(delisted.isListedInMarket, isFalse);
    });

    test('drops isNull back to false on the copy', () {
      // copyWith does not forward isNull, so copying a placeholder produces a
      // non-null item. Worth knowing before copying Item.empty().
      final copied = Item.empty().copyWith(itemName: 'resurrected');

      expect(copied.isNull, isFalse);
    });
  });

  group('Item.toJson', () {
    test('flattens the owner down to its id', () {
      final json = buildItem(itemOwner: buildUser(userID: 'owner-99')).toJson();

      expect(json['itemOwner'], 'owner-99');
    });

    test('writes the remaining fields verbatim', () {
      final item = buildItem(
        itemName: 'Desk Lamp',
        itemDescription: 'Adjustable arm.',
        imgs: ['a.png', 'b.png'],
        preferredInReturn: ['chair'],
        isPayment: false,
      );

      final json = item.toJson();

      expect(json['itemName'], 'Desk Lamp');
      expect(json['itemDescription'], 'Adjustable arm.');
      expect(json['imgs'], ['a.png', 'b.png']);
      expect(json['preferredInReturn'], ['chair']);
      expect(json['postedOn'], isA<Timestamp>());
      expect(json['isListedInMarket'], isTrue);
      expect(json['isPayment'], isFalse);
    });

    test('omits the itemID, which Firestore supplies as the document id', () {
      expect(buildItem().toJson().containsKey('itemID'), isFalse);
      expect(buildItem().toJson().containsKey('itemId'), isFalse);
    });
  });

  group('Item.doesItemContainQuery', () {
    test('matches on the item name, case-insensitively', () {
      final item = buildItem(itemName: 'Vintage Camera');

      expect(item.doesItemContainQuery('vintage'), isTrue);
      expect(item.doesItemContainQuery('VINTAGE'), isTrue);
      expect(item.doesItemContainQuery('Camera'), isTrue);
    });

    test('matches on the description', () {
      final item = buildItem(
        itemName: 'Camera',
        itemDescription: 'A 35mm film body.',
      );

      expect(item.doesItemContainQuery('35mm'), isTrue);
    });

    test('matches on the owner name', () {
      final item = buildItem(itemOwner: buildUser(userName: 'frankie'));

      expect(item.doesItemContainQuery('frank'), isTrue);
    });

    test('rejects a query that appears nowhere', () {
      final item = buildItem(
        itemName: 'Camera',
        itemDescription: 'A 35mm film body.',
        itemOwner: buildUser(userName: 'alice'),
      );

      expect(item.doesItemContainQuery('bicycle'), isFalse);
    });

    test('never matches a payment item, whatever the query', () {
      // Payment items reuse itemName/itemDescription to hold the amount, so
      // they are deliberately excluded from marketplace search results.
      final payment = buildItem(
        itemName: '50',
        itemDescription: 'EUR',
        isPayment: true,
      );

      expect(payment.doesItemContainQuery('50'), isFalse);
      expect(payment.doesItemContainQuery(''), isFalse);
    });

    test('matches everything on an empty query for a non-payment item', () {
      expect(buildItem().doesItemContainQuery(''), isTrue);
    });
  });

  group('Item.toString', () {
    test('surfaces the name, owner and payment flag for debugging', () {
      final text = buildItem(
        itemName: 'Skateboard',
        itemOwner: buildUser(userName: 'gina'),
      ).toString();

      expect(text, contains('Skateboard'));
      expect(text, contains('gina'));
      expect(text, contains('isPayment: false'));
    });
  });
}
