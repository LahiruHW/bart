// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:bart_app/common/constants/enum_login_types.dart';

// class BartAnalyticsEngine {
//   BartAnalyticsEngine._();

//   static late final FirebaseAnalytics _instance;
//   static late String? _currentUID;

//   static Future<void> init(
//     FirebaseApp app, {
//     String? uid,
//   }) async {
//     debugPrint('--------------------- INITIALIZING ANALYTICS ENGINE');
//     _instance = FirebaseAnalytics.instanceFor(app: app);
//     setCurrentUID(uid);
//     _instance.setAnalyticsCollectionEnabled(true);
//     _instance.setConsent(
//       adUserDataConsentGranted: true,
//       analyticsStorageConsentGranted: true,
//       adPersonalizationSignalsConsentGranted: true,
//       adStorageConsentGranted: true,
//       functionalityStorageConsentGranted: true,
//       personalizationStorageConsentGranted: true,
//       securityStorageConsentGranted: true,
//     );
//   }

//   static Future<void> setCurrentUID(String? uid) async {
//     _currentUID = uid;
//     await _instance.setUserId(id: uid);
//   }

//   static Future<void> logAppOpen() async {
//     debugPrint('--------------------- EVENT: logAppOpen');
//     await _instance.logAppOpen();
//   }

//   static Future<void> logAppClose() async {
//     debugPrint('--------------------- EVENT: logAppClose');
//     await _instance.logEvent(name: 'app_close');
//   }

//   static Future<void> userLogsInAE(LoginType loginType, String userID) async {
//     debugPrint('--------------------- EVENT: setting userID $userID');
//     setCurrentUID(userID);
//     debugPrint('--------------------- EVENT: userLogsInAE');
//     await _instance.logLogin(loginMethod: loginType.value);
//   }

//   static Future<void> userLogsOutAE() async {
//     debugPrint('--------------------- EVENT: removing set userID');
//     setCurrentUID(null);
//     debugPrint('--------------------- EVENT: userLogsOutAE');
//     await _instance.logEvent(name: 'user_logout');
//   }

//   static Future<void> userBeginsOnboarding() async {
//     debugPrint('--------------------- EVENT: userBeginsOnboarding');
//     await _instance.logEvent(name: 'begin_onboarding', parameters: {
//       'userID': _currentUID!,
//     });
//   }

//   static Future<void> userEndsOnboarding() async {
//     debugPrint('--------------------- EVENT: userEndsOnboarding');
//     await _instance.logEvent(name: 'end_onboarding', parameters: {
//       'userID': _currentUID!,
//     });
//   }


//   static Future<void> userGoToListedItems() async {
//     debugPrint('--------------------- EVENT: userGoToListedItems');
//     await _instance.logEvent(name: 'go_to_listed_items');
//   }

//   static Future<void> userGoToItemPage(String itemID) async {
//     debugPrint('--------------------- EVENT: userGoToItemPage');
//     await _instance.logEvent(name: 'go_to_item_page', parameters: {
//       'userID': _currentUID!,
//       'itemID': itemID,
//     });
//   }

//   static Future<void> userBeginsTutorial() async {
//     debugPrint('--------------------- EVENT: userBeginsTutorial');
//     await _instance.logTutorialBegin(parameters: {'userID': _currentUID!});
//   }

//   static Future<void> userEndsTutorial() async {
//     debugPrint('--------------------- EVENT: userEndsTutorial');
//     await _instance.logTutorialComplete(parameters: {'userID': _currentUID!});
//   }
// }
