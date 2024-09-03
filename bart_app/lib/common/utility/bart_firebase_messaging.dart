import 'dart:convert';
import 'package:bart_app/screens/index.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:bart_app/screens/shared/base.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// notifications when:
// 1. app is in the foreground
//    1.1. when a new trade is created
//    1.2. when status of a trade is updated
//    1.3. when a new message is received
//    1.4. when a new app update is available
// 2. app is in the background

// refer to this video: https://www.youtube.com/watch?v=k0zGEbiDJcQ&t=453s
class BartFirebaseMessaging {
  static late final FirebaseMessaging _fbMessaging;
  static late String? _fcmToken;
  static late final bool isAuthorized;
  static late final AndroidNotificationChannel _androidChannel;
  static late final FlutterLocalNotificationsPlugin _localNotifications;

  static Future<void> init() async {
    debugPrint('--------------------- INITIALIZING NOTIFICATIONS');

    _fbMessaging = FirebaseMessaging.instance;

    _androidChannel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications',
      importance: Importance.high,
    );
    _localNotifications = FlutterLocalNotificationsPlugin();

    // request permission from user to send notifications
    await _fbMessaging
        .requestPermission(announcement: true, provisional: true)
        .then(setAuthorizedStatus);
    if (!isAuthorized) return;

    _fcmToken = await _fbMessaging.getToken();
    debugPrint('||||||||||||||||||||||||| FCM Token: $_fcmToken');

    await _fbMessaging.setAutoInitEnabled(true);
    initPushNotifications();
    initLocalNotifications();
  }

  // same as handleBackgroundMessage
  static Future<void> _handleMessage(RemoteMessage? remoteMsg) async {
    if (remoteMsg == null) return;
    debugPrint('Title: ${remoteMsg.notification?.title}');
    debugPrint('Body: ${remoteMsg.notification?.body}');
    debugPrint('Payload: ${remoteMsg.data}');

    final String pathIfLoggedIn = remoteMsg.data['pathIfLoggedIn'];
    final String pathIfNotLoggedIn = remoteMsg.data['pathIfNotLoggedIn'];

    // resolve the route path based on the payload, then redirect to that path

    try {
      Base.globalKey.currentContext!.go(pathIfLoggedIn);
    } catch (e) {
      LoginTypeSelectPage.globalKey.currentContext!.go(pathIfNotLoggedIn);
    }

    // Base.globalKey.currentContext!.go('/chat');
  }

  static void setAuthorizedStatus(NotificationSettings status) {
    switch (status.authorizationStatus) {
      case AuthorizationStatus.authorized:
        isAuthorized = true;
        break;
      case AuthorizationStatus.provisional:
        isAuthorized = true;
        break;
      case AuthorizationStatus.denied:
        isAuthorized = false;
        break;
      case AuthorizationStatus.notDetermined:
        isAuthorized = false;
        break;
      default:
        isAuthorized = false;
        break;
    }
  }

  static Future<void> initPushNotifications() async {
    await _fbMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    ); // needed for iOS

    await _fbMessaging.getInitialMessage().then(_handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    FirebaseMessaging.onBackgroundMessage(_handleMessage);
    FirebaseMessaging.onMessage.listen(
      (msg) {
        final notif = msg.notification;
        if (notif == null) return;
        _localNotifications.show(
          notif.hashCode,
          notif.title,
          notif.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _androidChannel.id,
              _androidChannel.name,
              channelDescription: _androidChannel.description,
              importance: _androidChannel.importance,
              icon: '@drawable/launcher_icon',
            ),
          ),
          payload: jsonEncode(msg.toMap()),
        );
      },
    );
  }

  static Future<void> initLocalNotifications() async {
    const iOS = DarwinInitializationSettings();
    const android = AndroidInitializationSettings(
      '@drawable/launcher_icon',
    );
    const settings = InitializationSettings(android: android, iOS: iOS);
    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (payload) {
        print('||||||||||||||||||||||||| Received payload: ${payload.payload}');
        final message = RemoteMessage.fromMap(jsonDecode(payload.payload!));
        print('||||||||||||||||||||||||| Received notification: $message');
        _handleMessage(message);
      },
      // onDidReceiveBackgroundNotificationResponse: (payload) {
      //   print('||||||||||||||||||||||||| Received payload: ${payload.payload}');
      //   final message = RemoteMessage.fromMap(jsonDecode(payload.payload!));
      //   print('||||||||||||||||||||||||| Received notification: $message');
      //   _handleMessage(message);
      // },
    );

    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }
}
