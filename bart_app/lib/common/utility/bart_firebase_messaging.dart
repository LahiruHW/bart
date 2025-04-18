import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:bart_app/screens/shared/base.dart';
import 'package:bart_app/screens/login/login_select.dart';
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
  static late final FlutterLocalNotificationsPlugin _localNotifs;
  static late final NotificationDetails _notifDetails;
  static const String _picPathSmall = "@drawable/notification_icon";
  static const String _picPathBig = "@drawable/launcher_icon";

  static Future<void> init() async {
    debugPrint('--------------------- INITIALIZING NOTIFICATIONS');

    _fbMessaging = FirebaseMessaging.instance;

    _androidChannel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications',
      importance: Importance.high,
    );

    _notifDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        _androidChannel.id,
        _androidChannel.name,
        channelDescription: _androidChannel.description,
        importance: _androidChannel.importance,
        icon: _picPathSmall,
        largeIcon: const DrawableResourceAndroidBitmap(_picPathBig),
      ),
    );

    _localNotifs = FlutterLocalNotificationsPlugin();

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

    // TODO:_resolve the route path based on the payload, then redirect to that path
    try {
      Base.globalKey.currentContext!.go(pathIfLoggedIn);
    } catch (e) {
      LoginTypeSelectPage.globalKey.currentContext!.go(pathIfNotLoggedIn);
    }
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
        _localNotifs.show(
          notif.hashCode,
          notif.title,
          notif.body,
          _notifDetails,
          payload: jsonEncode(msg.toMap()),
        );
      },
    );
  }

  static Future<void> initLocalNotifications() async {
    const iOS = DarwinInitializationSettings();
    const android = AndroidInitializationSettings(_picPathSmall);
    const settings = InitializationSettings(android: android, iOS: iOS);
    await _localNotifs.initialize(
      settings,
      onDidReceiveNotificationResponse: (payload) {
        final message = RemoteMessage.fromMap(jsonDecode(payload.payload!));
        _handleMessage(message);
      },
    );

    final platform = _localNotifs.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  static Future<void> showLocalNotif(
      int id, String title, String body, String payload) async {
    await _localNotifs.show(id, title, body, _notifDetails, payload: payload); 
  }
}
