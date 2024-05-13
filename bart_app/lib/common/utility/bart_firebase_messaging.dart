import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';

class BartFirebaseMessaging {
  static final FirebaseMessaging _fbMessaging = FirebaseMessaging.instance;

  static Future<void> initNotifications() async {
    await FirebaseMessaging.instance.setAutoInitEnabled(true);

    // request permission from user to send notifications
    await _fbMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      provisional: true,
    );

    // fetch the FCM token for this device
    final _fcmToken = await _fbMessaging.getToken();

    // FCM TOKEN: cPB78PfjTDaNuZcnZTKjpp:APA91bGT__a53pqHnuF_ZAEpEbNRG44S_jfZDzpxa_biSOOp7evsxLnhg0HZdI6pfLDHgk7NMWTdebgWSXIE_jN9w3Tl_d7MVCI8dg_q1GdnzFqDXZPwnvgHRBiRQBO4Fv7YfURKeLkk

    debugPrint('||||||||||||||||||||||||| FCM Token: $_fcmToken');
  }
}
