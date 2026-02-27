import 'package:envied/envied.dart';

part 'bart_env.g.dart';

// every time you need to add a new field, add it to the .env file run:
//                dart run build_runner build

@Envied(path: '.env', allowOptionalFields: true)
abstract class BartEnv {
  @EnviedField(varName: 'sampleAPIKey')
  static const String sampleAPIKey = _BartEnv.sampleAPIKey;
  @EnviedField(varName: 'internalTestLink1')
  static const String internalTestLink1 = _BartEnv.internalTestLink1;
  @EnviedField(varName: 'internalTestLink2')
  static const String internalTestLink2 = _BartEnv.internalTestLink2;
  // @EnviedField(varName: 'closedTestLink', optional: true)
  // static const String? closedTestLink = _BartEnv.closedTestLink;
  @EnviedField(varName: 'fcmWebPushPrivate')
  static const String fcmWebPushPrivate = _BartEnv.fcmWebPushPrivate;
  @EnviedField(varName: 'fcmVapidKey')
  static const String fcmVapidKey = _BartEnv.fcmVapidKey;

  @EnviedField(varName: 'mailerUser')
  static const String mailerUser = _BartEnv.mailerUser;
  @EnviedField(varName: 'mailerPassword')
  static const String mailerPassword = _BartEnv.mailerPassword;
}
