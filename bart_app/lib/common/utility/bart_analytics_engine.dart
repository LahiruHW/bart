import 'package:flutter/foundation.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:bart_app/common/entity/user_local_profile.dart';

class BartAnalyticsEngine {
  BartAnalyticsEngine._();

  /// Only needed for Android and iOS
  ///
  /// Web configuration is done in the web/index.html file
  static Future<void> init() async {
    final config = PostHogConfig(
      'phc_ywkIkUhx5OOLUI2II9B45FgIaVtqCDFMaeTvW8OBKnj',
    );
    config.debug = kDebugMode || kProfileMode;
    config.captureApplicationLifecycleEvents = true;
    config.host = 'https://eu.i.posthog.com';
    config.personProfiles = PostHogPersonProfiles.always;
    if (!kIsWeb) await Posthog().setup(config);
  }

  static Future<void> identify(UserLocalProfile user, String email) async {
    await Posthog().identify(
      userId: email,
      userProperties: {
        'userID': user.userID,
        'userName': user.userName,
        'fullName': user.fullName,
        'isFirstLogin': user.isFirstLogin,
      },
    );
  }
}
