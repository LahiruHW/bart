import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bart_app/screens/shared/base.dart';
import 'package:bart_app/screens/login/login_select.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bart_app/common/utility/bart_route_handler.dart';
import 'package:bart_app/common/constants/env files/bart_env.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:bart_app/common/utility/bart_app_version_data.dart';

/// uses BartAppVersionData with Firebase RemoteConfig to check for app updates
class BartAppUpdateChecker {
  static late BuildContext _context;
  static late final FirebaseRemoteConfig config;
  static const String keyForceUpdate = 'force_update';
  static const String keyLatestVersion = 'latest_version';
  static const String keyLatestBuild = 'latest_build';
  static const String keyUpdateLink = 'update_link';
  static final Map<String, dynamic> thisConfig = {
    keyForceUpdate: false,
    keyLatestVersion: BartAppVersionData.version,
    keyLatestBuild: int.parse(BartAppVersionData.buildNumber),
    keyUpdateLink: BartEnv.internalTestLink2,
  };
  static final GlobalKey alertKey = GlobalKey();
  static bool _shouldUpdate = false;

  BartAppUpdateChecker._();

  static Future<void> initConfig() async {
    debugPrint('------------------------------ AppUpdateChecker initialized');
    config = FirebaseRemoteConfig.instance;
    await config.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 15),
        minimumFetchInterval: const Duration(minutes: 5),
      ),
    );
    await config.setDefaults(thisConfig);

    // Fetch the values from Firebase Remote Config
    await config.fetchAndActivate();

    if (!kIsWeb) {
      // Optional: listen for & activate changes to the Remote Config values
      config.onConfigUpdated.listen(updateCurrentConfig);
    } 
  }

  static Future<void> startupConfigCheck(BuildContext? context) async {
    _context = LoginTypeSelectPage.globalKey.currentContext ??
        Base.globalKey.currentContext ??
        context!;
    await config.fetch();
    debugPrint('--------------------- Remote Config at startup');
    config.getAll().entries.forEach((val) => resolveConfigKeys(val.key));
    debugPrint('--------------------- $thisConfig');
    await shouldUpdate();
  }

  /// only called within onConfigUpdated listener, not called at startup
  static void updateCurrentConfig(RemoteConfigUpdate event) async {
    await config.activate().then((_) async {
      debugPrint('--------------------- Remote Config updated');
      event.updatedKeys.forEach(resolveConfigKeys);
      debugPrint('--------------------- $thisConfig');
      await shouldUpdate();
    });
    await config.ensureInitialized();
  }

  static void resolveConfigKeys(String key) {
    switch (key) {
      case (keyForceUpdate):
        thisConfig[keyForceUpdate] = config.getBool(keyForceUpdate);
      case (keyLatestVersion):
        thisConfig[keyLatestVersion] = config.getString(keyLatestVersion);
      case (keyLatestBuild):
        thisConfig[keyLatestBuild] = config.getValue(keyLatestBuild).asInt();
      case (keyUpdateLink):
        thisConfig[keyUpdateLink] = config.getString(keyUpdateLink);
      default:
        break;
    }
  }

  static bool get forceUpdate => thisConfig[keyForceUpdate];
  static String get latestVersion => thisConfig[keyLatestVersion];
  static int get latestBuild => thisConfig[keyLatestBuild];

  static Future<void> shouldUpdate() async {
    if (forceUpdate) return await showUpdateDialog();
    final List<int> currentVerArr =
        BartAppVersionData.version.split('.').map(int.parse).toList();
    final List<int> latestVerArr =
        latestVersion.split('.').map(int.parse).toList();
    if (currentVerArr.length != latestVerArr.length) {
      throw Exception('Version number length mismatch!');
    }
    bool isVersionUpdated = true;
    for (int i = 0; i < currentVerArr.length; i++) {
      if (latestVerArr[i] == 0 && currentVerArr[i] == 0) continue;
      isVersionUpdated &= (latestVerArr[i] > currentVerArr[i]);
    }
    final int currentBuild = int.parse(BartAppVersionData.buildNumber);
    final isBuildUpdated = latestBuild > currentBuild;
    _shouldUpdate = (isVersionUpdated || isBuildUpdated);
    await showUpdateDialog();
  }

  static Future<void> showUpdateDialog() async {
    // if the app is up to date,
    if (!_shouldUpdate) {
      // don't show the dialog, and pop one if it exists
      if (alertKey.currentContext != null) {
        alertKey.currentContext!.pop();
      }
      return;
    }
    // if the app needs to update
    else {
      // if the dialog is already in view, don't show another one
      if (alertKey.currentContext != null) return;

      debugPrint('--------------------- showing update dialog');
      // else show the dialog
      _context = LoginTypeSelectPage.globalKey.currentContext ??
          Base.globalKey.currentContext ??
          alertKey.currentContext!;

      await showDialog(
        context: _context,
        barrierDismissible: false,
        builder: (context) => BartRouteHandler.popResistantWrapper(
          child: AlertDialog(
            key: alertKey,
            title: Text(tr('update.dialog.1.header')),
            content: Text(tr('update.dialog.1.body')),
            actions: [
              TextButton(
                onPressed: () {
                  // final uri = Uri.parse(BartEnv.internalTestLink2);
                  final uri = Uri.parse(thisConfig[keyUpdateLink]);
                  launchUrl(uri).then((_) => SystemNavigator.pop());
                },
                child: Text(tr('update.dialog.1.btn')),
              ),
            ],
          ),
        ),
      );
    }
  }
}
