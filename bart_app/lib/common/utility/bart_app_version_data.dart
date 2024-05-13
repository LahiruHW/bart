import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class BartAppVersionData {
  static late final PackageInfo packageInfo;

  BartAppVersionData() {
    debugPrint('------------------------------ AppVersionProvider initialized');
  }

  static void initPackageInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
  }

  static String get appName => packageInfo.appName;
  static String get packageName => packageInfo.packageName;
  static String get version => packageInfo.version;
  static String get buildNumber => packageInfo.buildNumber;
}
