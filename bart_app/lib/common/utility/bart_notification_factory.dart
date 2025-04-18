import 'dart:convert';
import 'package:bart_app/common/utility/bart_firebase_messaging.dart';

/// contains methods to create and show notifications for different events
class BartLNFactory {
  BartLNFactory._();

  /// create local notification when there are new messages in a chat
  static Future<void>? notifyNewChatMsgs(
    String chatID,
    int unreadMsgCount,
    String fromUser,
  ) async {
    final payload = {
      'pathIfLoggedIn': '/chat',
      'pathIfNotLoggedIn': '/login',
    };
    if (unreadMsgCount > 0) {
      BartFirebaseMessaging.showLocalNotif(
        0,
        'New message from $fromUser',
        'You have $unreadMsgCount new messages from $fromUser',
        jsonEncode(payload),
      );
    }

    // BartFirebaseMessaging.
  }
}
