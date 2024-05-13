
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserSettings {
  late bool isDarkMode;
  late Timestamp? lastUpdated;
  late String? lastUpdatedString;

  UserSettings({
    this.isDarkMode = false,
    this.lastUpdated,
    this.lastUpdatedString,
  });

  void updateSettings({
    bool? isDarkMode,
    DateTime? lastUpdated,
    String? lastUpdatedString,
  }) {
    final currrentTimeStamp = Timestamp.now();
    final currrentTimeStampString =
        currrentTimeStamp.toDate().toIso8601String(); // for debugging

    this.isDarkMode = isDarkMode ?? this.isDarkMode;
    this.lastUpdated = currrentTimeStamp;
    this.lastUpdatedString = currrentTimeStampString;
    debugPrint('Settings updated: $this');
  }

  factory UserSettings.fromMap(Map<String, dynamic> json) {
    return UserSettings(
      isDarkMode: json['isDarkMode'],
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
      lastUpdated: newObj.lastUpdated ?? old.lastUpdated ?? timeNow,
      lastUpdatedString: newObj.lastUpdatedString ??
          old.lastUpdatedString ??
          timeNow.toDate().toIso8601String(),
    );
  }

  Map<String, dynamic> toMap() => {
        'isDarkMode': isDarkMode,
        'lastUpdated': lastUpdated ?? Timestamp.now(),
      };

  /// for decoding from json (used by shared preferences)
  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      isDarkMode: json['isDarkMode'],
      lastUpdated: Timestamp.fromDate(DateTime.parse(json['lastUpdated'])),
      lastUpdatedString: json['lastUpdatedString'],
    );
  }

  /// for encoding to json (used by shared preferences)
  Map<String, dynamic> toJson() {
    final timeNow = Timestamp.now();
    return {
      'isDarkMode': isDarkMode,
      'lastUpdated': lastUpdatedString ?? timeNow.toDate().toIso8601String(),   // JSON cannot parse Timestamp!!
      'lastUpdatedString': lastUpdatedString ?? timeNow.toDate().toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Settings: {isDarkMode: $isDarkMode, lastUpdated: $lastUpdated, lastUpdatedString: $lastUpdatedString}';
  }
}
