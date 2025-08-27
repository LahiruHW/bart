import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Based on the Flutter Local Notifications plugin documentation and this video:
// https://www.youtube.com/watch?v=rT7-p5t_35c

/// All code related to handling Local Notifications will be handled here.
class BartLocalNotificationHandler {
  BartLocalNotificationHandler._();

  static late final FlutterLocalNotificationsPlugin
      flutterLocalNotificationsPlugin;

  static const String _channelId = 'channel_Id';
  static const String _channelName = 'channel_Name';

  /// Initialize the [BartLocalNotificationHandler] class and all the necessary
  /// plugins required to handle notifications.
  static Future<void> init() async {
    if (kIsWeb) return;
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // Android initialization settings
    const AndroidInitializationSettings initSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_launcher');

    // iOS initialization settings
    const DarwinInitializationSettings initSettingsDarwin =
        DarwinInitializationSettings();

    // combine Android and iOS initialization settings
    const InitializationSettings initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsDarwin,
    );

    // request notification permissions for Android
    final platform =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await platform!.requestNotificationsPermission().then((value) {
      debugPrint(
          '--------------------------------- Notification Permission: ${value! ? "✅" : "❌"}');
    });
    await platform.requestExactAlarmsPermission().then((value) {
      debugPrint(
          '--------------------------------- Exact Alarms Permission: ${value! ? "✅" : "❌"}');
    });
    await platform.requestFullScreenIntentPermission().then((value) {
      debugPrint(
          '--------------------------------- Full Screen Intent Permission: ${value! ? "✅" : "❌"}');
    });

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: onLocalNotificationClicked,
      // onDidReceiveBackgroundNotificationResponse:
      //     onDidReceiveBackgroundNotification,
    );

    debugPrint(
      '------------------------- BartLocalNotificationHandler initialized',
    );
  }

  /// Callback function for when a local notification is clicked
  static void onLocalNotificationClicked(NotificationResponse response) {
    debugPrint(
        'onLocalNotificationClicked ------------------------------ Notification Received');
    debugPrint(
        'onLocalNotificationClicked ------------------------------ Response Payload: ${response.payload}');
    final Map<String, dynamic> payloadData = jsonDecode(response.payload!);
    debugPrint(
        'onLocalNotificationClicked ------------------------------ Response Payload Data: $payloadData');

    // final rm = RemoteMessageData.fromMap(payloadData);
    final rm = payloadData;

    debugPrint('onLocalNotificationClicked ------------------------------ $rm');

    // XpressRouter.rootNavKey.currentState?.context.goNamed('home', extra: rm);
  }

  /// Show an instant notifications (from both the Local Plugin and FCM)
  ///
  /// Only works when the app is in the foreground.
  static Future<void> showInstantNotification({
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  }) async {
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        importance: Importance.high,
        priority: Priority.high,
        silent: false,
        color: Color.fromRGBO(255, 56, 96, 1.0),
        actions: [
          AndroidNotificationAction("open", "Open", showsUserInterface: true),
          AndroidNotificationAction("ign", "Ignore", cancelNotification: true),
        ],
        visibility: NotificationVisibility.public,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: (payload != null) ? jsonEncode(payload) : null,
    );
  }

  /// Schedule a notification to be shown with the given `scheduledDate`.
  ///
  /// Only works when the app is in the foreground, if the app is terminated
  /// while a notification is scheduled, it will not be shown.
  static Future<void> scheduledNotification({
    required String title,
    required String body,
    required DateTime scheduledDate,
    Map<String, dynamic>? payload,
  }) async {
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        importance: Importance.high,
        priority: Priority.high,
        silent: false,
        actions: [
          AndroidNotificationAction("open", "Open", showsUserInterface: true),
          AndroidNotificationAction("ign", "Ignore", cancelNotification: true),
        ],
        visibility: NotificationVisibility.public,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      platformChannelSpecifics,
      // uiLocalNotificationDateInterpretation:
      //     UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: (payload != null) ? jsonEncode(payload) : null,
    );
  }

  /// show a RemoteMessage as an instant notification
  static Future<void> showFCMInstantNotification(RemoteMessage message) async {
    final title = message.notification?.title ?? 'No Title';
    final body = message.notification?.body ?? 'No Body';
    final payload = message.data;
    await showInstantNotification(title: title, body: body, payload: payload);
  }
}

// /// Callback function for when a notification is received, in the background.
// @pragma('vm:entry-point')
// void onDidReceiveBackgroundNotification(NotificationResponse response) {
//   debugPrint(
//       'onDidReceiveBackgroundNotification ------------------------ BACKGROUND LOCAL Notification Received');
//   debugPrint(
//       'onDidReceiveBackgroundNotification ------------------------ BACKGROUND LOCAL Response Payload: ${response.payload}');
//   final payloadData = jsonDecode(response.payload!);
//   debugPrint(
//       'onDidReceiveBackgroundNotification ------------------------- BACKGROUND LOCAL Response Payload Data: $payloadData');
// }