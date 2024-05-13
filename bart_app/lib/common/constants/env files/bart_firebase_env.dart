// // make a bash script to read the firebase_options file in the /lib folder, and put them in the env file

// // first get the platform from the firebase_options file

// // you should take the following properties from the firebase_options file:
// // apiKey
// // appId
// // messagingSenderId
// // projectId
// // authDomain
// // storageBucket
// // androidClientId
// // iosClientId
// // iosBundleId

// //

// import 'package:envied/envied.dart';
// import 'package:firebase_core/firebase_core.dart';
// // part 'bart_firebase_env.g.dart';

// @Envied(path: 'BART_FIREBASE.env', allowOptionalFields: true)
// abstract class FirebaseEnv {
//   @EnviedField(varName: 'apiKey')
//   static String apiKey = _FirebaseEnv.apiKey;

//   @EnviedField(varName: 'appId')
//   static String appId = _FirebaseEnv.appId;

//   @EnviedField(varName: 'messagingSenderId')
//   static String messagingSenderId = _FirebaseEnv.messagingSenderId;

//   @EnviedField(varName: 'projectId')
//   static String projectId = _FirebaseEnv.projectId;

//   @EnviedField(varName: 'authDomain')
//   static String authDomain = _FirebaseEnv.authDomain;

//   @EnviedField(varName: 'storageBucket')
//   static String storageBucket = _FirebaseEnv.storageBucket;

//   @EnviedField(varName: 'androidClientId', optional: true)
//   static String? androidClientId = _FirebaseEnv.androidClientId;

//   @EnviedField(varName: 'iosClientId', optional: true)
//   static String? iosClientId = _FirebaseEnv.iosClientId;

//   @EnviedField(varName: 'iosBundleId', optional: true)
//   static String? iosBundleId = _FirebaseEnv.iosBundleId;

//   static FirebaseOptions get envFirebaseOptions => FirebaseOptions(
//         apiKey: apiKey,
//         appId: appId,
//         messagingSenderId: messagingSenderId,
//         projectId: projectId,
//         authDomain: authDomain,
//         storageBucket: storageBucket,
//         androidClientId: androidClientId ?? "",
//         iosClientId: iosClientId ?? "",
//         iosBundleId: iosBundleId ?? "",
//       );
// }
