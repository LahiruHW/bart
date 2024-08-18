
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserSettings {
  late bool isDarkMode;
  late bool isLegacyUI;
  late Timestamp? lastUpdated;
  late String? lastUpdatedString;

  UserSettings({
    this.isDarkMode = false,
    this.isLegacyUI = false,
    this.lastUpdated,
    this.lastUpdatedString,
  });

  void updateSettings({
    bool? isDarkMode,
    bool? isLegacyUI,
    DateTime? lastUpdated,
    String? lastUpdatedString,
  }) {
    final currrentTimeStamp = Timestamp.now();
    final currrentTimeStampString =
        currrentTimeStamp.toDate().toIso8601String(); // for debugging

    this.isDarkMode = isDarkMode ?? this.isDarkMode;
    this.isLegacyUI = isLegacyUI ?? this.isLegacyUI;
    this.lastUpdated = currrentTimeStamp;
    this.lastUpdatedString = currrentTimeStampString;
    debugPrint('Settings updated: $this');
  }

  factory UserSettings.fromMap(Map<String, dynamic> json) {
    return UserSettings(
      isDarkMode: json['isDarkMode'],
      isLegacyUI: json['isLegacyUI'],
      lastUpdated: json['lastUpdated'],
      lastUpdatedString: json['lastUpdatedString'],
    );
  }

  factory UserSettings.mergeWithExisting(
      UserSettings old, UserSettings newObj) {
    debugPrint('||||||||||||||||||||||||---------- MERGING SETTINGS');
    final timeNow = Timestamp.now();
    return UserSettings(
      isDarkMode: old.isDarkMode,
      isLegacyUI: old.isLegacyUI,
      lastUpdated: newObj.lastUpdated ?? old.lastUpdated ?? timeNow,
      lastUpdatedString: newObj.lastUpdatedString ??
          old.lastUpdatedString ??
          timeNow.toDate().toIso8601String(),
    );
  }

  Map<String, dynamic> toMap() => {
        'isDarkMode': isDarkMode,
        'isLegacyUI': isLegacyUI,
        'lastUpdated': lastUpdated ?? Timestamp.now(),
      };

  /// for decoding from json (used by shared preferences)
  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      isDarkMode: json['isDarkMode'],
      isLegacyUI: json['isLegacyUI'],
      lastUpdated: Timestamp.fromDate(DateTime.parse(json['lastUpdated'])),
      lastUpdatedString: json['lastUpdatedString'],
    );
  }

  /// for encoding to json (used by shared preferences)
  Map<String, dynamic> toJson() {
    final timeNow = Timestamp.now();
    return {
      'isDarkMode': isDarkMode,
      'isLegacyUI': isLegacyUI,
      'lastUpdated': lastUpdatedString ?? timeNow.toDate().toIso8601String(),   // JSON cannot parse Timestamp!!
      'lastUpdatedString': lastUpdatedString ?? timeNow.toDate().toIso8601String(),
    };
  }

  @override
  String toString() {
    // return 'Settings: {isDarkMode: $isDarkMode, lastUpdated: $lastUpdated, lastUpdatedString: $lastUpdatedString}';
    return 'Settings: {isDarkMode: $isDarkMode, isLegacyUI: $isLegacyUI, lastUpdated: $lastUpdated, lastUpdatedString: $lastUpdatedString}';
  }
}
