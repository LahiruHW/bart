import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:bart_app/common/utility/bart_router.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:bart_app/common/constants/env/bart_env.dart';
import 'package:bart_app/common/utility/notifications/bart_local_notification_handler.dart';

class BartFirebaseNotificationHandler {
  BartFirebaseNotificationHandler._();

  static late final FirebaseMessaging _messaging;
  static late final NotificationSettings _settings;
  static String currentToken = "";

  static Future<void> init() async {
    _messaging = FirebaseMessaging.instance;
    await requestFCMPermission();
    if (_settings.authorizationStatus == AuthorizationStatus.denied) return;
    await _messaging.setAutoInitEnabled(true);

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // currentToken = await _messaging.getToken() ?? "";
    currentToken = await _messaging.getToken(
          vapidKey: kIsWeb ? BartEnv.fcmVapidKey : null,
        ) ??
        "";
    debugPrint('------------------------------ FCM Token: $currentToken');

    _messaging.onTokenRefresh.listen((newToken) {
      currentToken = newToken;
      debugPrint('------------------------ refreshed FCM Token: $currentToken');
    }).onError((error) {
      debugPrint('------------------------ FCM Token Refresh Error: $error');
    });

    await _messaging.getInitialMessage().then(onRemoteMessageClicked);

    // Handle foreground messages using the Flutter Local Notifications Plugin (only)
    if (!kIsWeb) {
      FirebaseMessaging.onMessage.listen(
        BartLocalNotificationHandler.showFCMInstantNotification,
      );
    } else {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // debugPrint(
        //     '------------------------ FCM Message Received: ${message.data}');
        // debugPrint(
        //     '------------------------ FCM Message Notification: ${message.notification}');
        showDialog(
          context: BartRouter.rootNavKey.currentContext!,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(message.notification?.title ?? 'No Title'),
              content: Text(message.notification?.body ?? 'No Body'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      });
    }

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(onBackgroundRemoteMessageReceived);

    FirebaseMessaging.onMessageOpenedApp.listen(onRemoteMessageClicked);

    debugPrint(
      '--------------------------- BartFirebaseNotificationHandler initialized',
    );
  }

  /// Request permission to receive FCM notifications
  static Future<void> requestFCMPermission() async {
    _settings = await _messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      providesAppNotificationSettings: true,
      provisional: true,
      sound: true,
    );
    _settings.authorizationStatus == AuthorizationStatus.authorized
        ? debugPrint('----------------------------- FCM Permission Granted ✅')
        : debugPrint('----------------------------- FCM Permission Denied ❌');
  }

  /// Handle the initial message when the app is opened from a terminated state
  ///
  /// Only supported on iOS and Android, not on Web.
  static Future<void> handleIntialMessage() async {
    final initMessage = await _messaging.getInitialMessage();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async => await onRemoteMessageClicked(initMessage),
    );
  }

  /// Callback function for when a FCM notifications is clicked, and causes the
  /// app to open
  @pragma('vm:entry-point')
  static Future<void> onRemoteMessageClicked(RemoteMessage? message) async {
    debugPrint('onRemoteMessageClicked triggered');
    if (message == null) return;
    debugPrint(
        'onRemoteMessageClicked ------------------------------- FCM Message Received');
    debugPrint(
        'onRemoteMessageClicked ------------------------------- FCM Message Data: ${message.data}');
    debugPrint(
        'onRemoteMessageClicked ------------------------------- FCM Message Notification: ${message.notification}');
    // final rm = RemoteMessageData.fromMap(message.data);
    final rm = message.data;
    debugPrint('onRemoteMessageClicked ------------------------------- $rm');

    // XpressRouter.rootNavKey.currentState?.context
    //     .replaceNamed('home', extra: rm);
  }
}

/// Callback function for when a notification is received, in the background
@pragma('vm:entry-point')
Future<void> onBackgroundRemoteMessageReceived(RemoteMessage? message) async {
  debugPrint('onBackgroundRemoteMessageReceived triggered');
  if (message == null) return;
  debugPrint(
      'onBackgroundRemoteMessageReceived ------------------------------- BACKGROUND FCM Message Received');
  debugPrint(
      'onBackgroundRemoteMessageReceived ------------------------------- FCM Message Data: ${message.data}');
  debugPrint(
      'onBackgroundRemoteMessageReceived ------------------------------- FCM Message Notification: ${message.notification}');
  // final rm = RemoteMessageData.fromMap(message.data);
  // final rm = message.data;

  // XpressRouter.rootNavKey.currentState?.context.goNamed('home', extra: rm);
}
