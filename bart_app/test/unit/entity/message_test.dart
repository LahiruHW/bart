import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bart_app/common/entity/message.dart';

import '../../helpers/fixtures.dart';

void main() {
  group('Message construction', () {
    test('defaults the optional flags to false and extra to empty', () {
      final message = Message(
        timeSent: kFixedTimestamp,
        senderID: 'user-1',
        text: 'hi',
      );

      expect(message.messageID, isEmpty);
      expect(message.senderName, isEmpty);
      expect(message.isSharedTrade, isFalse);
      expect(message.isSharedItem, isFalse);
      expect(message.isRead, isFalse);
      expect(message.extra, isEmpty);
    });
  });

  group('Message.fromMap', () {
    test('reads a plain text message off the Firestore document', () {
      final message = Message.fromMap({
        'msgID': 'msg-11',
        'timeSent': kFixedTimestamp,
        'senderID': 'user-3',
        'senderName': 'harry',
        'text': 'is this still available?',
        'isSharedTrade': false,
        'isSharedItem': false,
        'isRead': true,
        'extra': <String, dynamic>{},
      });

      expect(message.messageID, 'msg-11');
      expect(message.timeSent, kFixedTimestamp);
      expect(message.senderID, 'user-3');
      expect(message.senderName, 'harry');
      expect(message.text, 'is this still available?');
      expect(message.isSharedTrade, isFalse);
      expect(message.isSharedItem, isFalse);
      expect(message.isRead, isTrue);
      expect(message.extra, isEmpty);
    });

    test('reads the id from "msgID", not "messageID"', () {
      // The Firestore field name differs from the Dart property name; a rename
      // on either side would otherwise silently produce a null id.
      final message = Message.fromMap({
        'msgID': 'msg-12',
        'timeSent': kFixedTimestamp,
        'senderID': 'user-3',
        'senderName': 'harry',
        'text': 'hello',
        'isSharedTrade': false,
        'isSharedItem': false,
        'isRead': false,
        'extra': <String, dynamic>{},
      });

      expect(message.messageID, 'msg-12');
    });
  });

  group('Message.toMap for a plain message', () {
    test('writes the message fields and an empty extra payload', () {
      final map = buildMessage(
        senderID: 'user-2',
        senderName: 'iris',
        text: 'on my way',
        isRead: true,
      ).toMap();

      expect(map['timeSent'], isA<Timestamp>());
      expect(map['senderID'], 'user-2');
      expect(map['senderName'], 'iris');
      expect(map['text'], 'on my way');
      expect(map['isRead'], isTrue);
      expect(map['isSharedTrade'], isFalse);
      expect(map['isSharedItem'], isFalse);
      expect(map['extra'], isEmpty);
    });

    test(
      'omits the messageID, which Firestore supplies as the document id',
      () {
        final map = buildMessage(messageID: 'msg-99').toMap();

        expect(map.containsKey('msgID'), isFalse);
        expect(map.containsKey('messageID'), isFalse);
      },
    );

    test('passes an arbitrary extra payload straight through', () {
      final map = buildMessage(extra: {'foo': 'bar'}).toMap();

      expect(map['extra'], {'foo': 'bar'});
    });
  });

  group('Message.toMap for a shared item', () {
    test('collapses the embedded Item down to its id', () {
      final item = buildItem(itemID: 'item-77');
      final message = buildMessage(
        text: 'have a look at this',
        isSharedItem: true,
        extra: {'itemContent': item},
      );

      final map = message.toMap();

      expect(map['isSharedItem'], isTrue);
      expect(map['extra'], {'itemContent': 'item-77'});
    });

    test('throws when the shared item payload is missing', () {
      // _extraToMap casts extra['itemContent'] to Item unconditionally once
      // isSharedItem is set, so the two must always be written together.
      final message = buildMessage(isSharedItem: true, extra: const {});

      expect(() => message.toMap(), throwsA(isA<TypeError>()));
    });
  });

  group('Message.toMap for a shared trade', () {
    test('collapses the embedded Trade down to its id', () {
      final trade = buildTrade(tradeID: 'trade-88');
      final message = buildMessage(
        text: 'proposing this trade',
        isSharedTrade: true,
        extra: {'tradeContent': trade},
      );

      final map = message.toMap();

      expect(map['isSharedTrade'], isTrue);
      expect(map['extra'], {'tradeContent': 'trade-88'});
    });

    test('a shared item takes precedence when both flags are set', () {
      // _extraToMap checks isSharedItem first and returns early, so a message
      // flagged as both only ever persists the item.
      final message = buildMessage(
        isSharedItem: true,
        isSharedTrade: true,
        extra: {
          'itemContent': buildItem(itemID: 'item-1'),
          'tradeContent': buildTrade(tradeID: 'trade-1'),
        },
      );

      expect(message.toMap()['extra'], {'itemContent': 'item-1'});
    });
  });

  group('Message.isSameDayAsMsg', () {
    test('is true for two messages sent on the same calendar day', () {
      final a = buildMessage(messageID: 'a', timeSent: kFixedTimestamp);
      final b = buildMessage(messageID: 'b', timeSent: kSameDayTimestamp);

      expect(a.isSameDayAsMsg(b), isTrue);
      expect(b.isSameDayAsMsg(a), isTrue);
    });

    test('is false across a day boundary', () {
      final a = buildMessage(messageID: 'a', timeSent: kFixedTimestamp);
      final b = buildMessage(messageID: 'b', timeSent: kNextDayTimestamp);

      expect(a.isSameDayAsMsg(b), isFalse);
    });

    test('is true when compared against itself', () {
      final message = buildMessage();

      expect(message.isSameDayAsMsg(message), isTrue);
    });

    test('drives the date separators in a chat list', () {
      // A chat renders a date divider wherever two adjacent messages fall on
      // different days; this is that grouping decision in miniature.
      final thread = [
        buildMessage(messageID: 'm1', timeSent: kFixedTimestamp),
        buildMessage(messageID: 'm2', timeSent: kSameDayTimestamp),
        buildMessage(messageID: 'm3', timeSent: kNextDayTimestamp),
      ];

      final dividerBefore = <String>[];
      for (var i = 1; i < thread.length; i++) {
        if (!thread[i].isSameDayAsMsg(thread[i - 1])) {
          dividerBefore.add(thread[i].messageID);
        }
      }

      expect(dividerBefore, ['m3']);
    });
  });

  group('Message.toString', () {
    test('surfaces the sender and text for debugging', () {
      final text = buildMessage(
        messageID: 'msg-4',
        senderName: 'jo',
        text: 'see you then',
      ).toString();

      expect(text, contains('msg-4'));
      expect(text, contains('jo'));
      expect(text, contains('see you then'));
    });
  });
}
