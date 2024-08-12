import 'package:envied/envied.dart';

part 'bart_env.g.dart';

// every time you need to add a new field, add it to the .env file run:
//                dart run build_runner build

@Envied(path: '.env', allowOptionalFields: true)
abstract class BartEnv {
  @EnviedField(varName: 'sampleAPIKey')
  static const String sampleAPIKey = _BartEnv.sampleAPIKey;
}
