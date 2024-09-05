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
}
