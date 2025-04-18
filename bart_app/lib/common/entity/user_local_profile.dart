import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bart_app/common/entity/settings.dart';

class UserLocalProfile {
  final String userID;
  String userName;
  String fullName;
  bool isFirstLogin;
  final List<String> chats; // list of chatIDs
  String? imageUrl;
  UserSettings? settings;
  String? localeString;
  bool isNull;
  Timestamp? lastUpdated;

  UserLocalProfile({
    this.userID = "",
    this.userName = "",
    this.fullName = "",
    this.isFirstLogin = true,
    this.chats = const [],
    this.imageUrl,
    this.settings,
    this.localeString = "en",
    this.isNull = false,
    this.lastUpdated,
  });

  static final UserLocalProfile _invalidObj = UserLocalProfile(
    userID: "",
    userName: "Deleted User",
    fullName: "Deleted User",
    isFirstLogin: false,
    chats: [],
    imageUrl: null,
    settings: null,
    localeString: null,
    isNull: true,
    lastUpdated: null,
  );
  factory UserLocalProfile.empty() => _invalidObj;

  factory UserLocalProfile.fromMap(Map<String, dynamic> json) {
    return UserLocalProfile(
      userID: json['userID'],
      userName: json['userName'],
      fullName: json['fullName'],
      chats: List<String>.from(json['chats'] ?? []),
      isFirstLogin: json['isFirstLogin'],
      imageUrl: json['imageUrl'],
      settings: UserSettings.fromMap(json['settings']),
      localeString: json['localeString'],
      lastUpdated: json['lastUpdated'] ?? Timestamp.now(),
    );
  }

  /// merge the new settings with the existing local settings
  factory UserLocalProfile.mergeCurrentSettings(
      UserLocalProfile old, UserLocalProfile newObj) {
    return UserLocalProfile(
      userID: newObj.userID,
      userName: newObj.userName,
      fullName: newObj.fullName,
      chats: newObj.chats,
      isFirstLogin: newObj.isFirstLogin,
      imageUrl: newObj.imageUrl,
      settings: UserSettings.mergeWithExisting(old.settings!, newObj.settings!),
      localeString: newObj.localeString,
      lastUpdated: newObj.lastUpdated ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'userName': userName,
        'fullName': fullName,
        'chats': FieldValue.arrayUnion(chats),
        'isFirstLogin': isFirstLogin,
        'imageUrl': imageUrl ?? "",
        'settings': (settings ?? UserSettings()).toMap(),
        'localeString': localeString,
        'lastUpdated': lastUpdated ?? Timestamp.now(),
      };

  /// for decoding from json (used by shared preferences)
  factory UserLocalProfile.fromJson(Map<String, dynamic> json) {
    return UserLocalProfile(
      userID: json['userID'],
      userName: json['userName'],
      fullName: json['fullName'],
      chats: List<String>.from(json['chats'] ?? []),
      isFirstLogin: json['isFirstLogin'],
      imageUrl: json['imageUrl'],
      settings: UserSettings.fromJson(json['settings']),
      localeString: json['localeString'] ?? 'en',
      lastUpdated: Timestamp.fromDate(DateTime.parse(json['lastUpdated'])),
    );
  }

  /// for encoding to json (used by shared preferences)
  Map<String, dynamic> toJson() => {
        'userID': userID,
        'userName': userName,
        'fullName': fullName,
        'chats': chats,
        'isFirstLogin': isFirstLogin,
        'imageUrl': imageUrl,
        'settings': settings?.toJson(),
        'localeString': localeString,
        'lastUpdated':
            (lastUpdated ?? Timestamp.now()).toDate().toIso8601String(),
      };

  // get the Locale object from the string
  Locale localeFromString(String localeString) {
    final tags = localeString.split('-');
    final retLocale = tags.length > 1
        ? Locale.fromSubtags(languageCode: tags[0], countryCode: tags[1])
        : Locale.fromSubtags(languageCode: tags[0]);
    return retLocale;
  }

  void updateLocaleString(String newLS) {
    final locale = localeFromString(newLS);
    localeString = locale.countryCode == null
        ? locale.languageCode
        : '${locale.languageCode}-${locale.countryCode}';
    lastUpdated = Timestamp.now();
  }

  @override
  String toString() {
    return 'UserLocalProfile: {userID: $userID, userName: $userName, fullName: $fullName, locale: $localeString, isFirstLogin: $isFirstLogin, imageUrl: $imageUrl, $settings, chats: $chats}';
  }
}
