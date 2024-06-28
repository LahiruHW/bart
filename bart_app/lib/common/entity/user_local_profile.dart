import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bart_app/common/entity/settings.dart';

class UserLocalProfile {
  final String userID;
  String userName;
  bool isFirstLogin;
  final List<String> chats; // list of chatIDs
  String? imageUrl;
  UserSettings? settings;
  String? localeString;
  bool isNull;

  UserLocalProfile({
    this.userID = "",
    this.userName = "",
    this.isFirstLogin = true,
    this.chats = const [],
    this.imageUrl,
    this.settings,
    this.localeString = "en",
    this.isNull = false,
  });

  static final UserLocalProfile _invalidObj = UserLocalProfile(
    userID: "",
    userName: "Deleted User",
    isFirstLogin: false,
    chats: [],
    imageUrl: null,
    settings: null,
    localeString: null,
    isNull: true,
  );
  factory UserLocalProfile.empty() => _invalidObj;

  factory UserLocalProfile.fromMap(Map<String, dynamic> json) {
    return UserLocalProfile(
      userID: json['userID'],
      userName: json['userName'],
      chats: List<String>.from(json['chats'] ?? []),
      isFirstLogin: json['isFirstLogin'],
      imageUrl: json['imageUrl'],
      settings: UserSettings.fromMap(json['settings']),
      localeString: json['localeString'],
    );
  }

  /// merge the new settings with the existing local settings
  factory UserLocalProfile.mergeCurrentSettings(
      UserLocalProfile old, UserLocalProfile newObj) {
    return UserLocalProfile(
      userID: newObj.userID,
      userName: newObj.userName,
      chats: newObj.chats,
      isFirstLogin: newObj.isFirstLogin,
      imageUrl: newObj.imageUrl,
      settings: UserSettings.mergeWithExisting(old.settings!, newObj.settings!),
      localeString: newObj.localeString,
    );
  }

  Map<String, dynamic> toMap() => {
        'userName': userName,
        'chats': FieldValue.arrayUnion(chats),
        'isFirstLogin': isFirstLogin,
        'imageUrl': imageUrl ?? "",
        'settings': (settings ?? UserSettings()).toMap(),
        'localeString': localeString,
      };

  /// for decoding from json (used by shared preferences)
  factory UserLocalProfile.fromJson(Map<String, dynamic> json) {
    return UserLocalProfile(
      userID: json['userID'],
      userName: json['userName'],
      chats: List<String>.from(json['chats'] ?? []),
      isFirstLogin: json['isFirstLogin'],
      imageUrl: json['imageUrl'],
      settings: UserSettings.fromJson(json['settings']),
      localeString: json['localeString'] ?? 'en',
    );
  }

  /// for encoding to json (used by shared preferences)
  Map<String, dynamic> toJson() => {
        'userID': userID,
        'userName': userName,
        'chats': chats,
        'isFirstLogin': isFirstLogin,
        'imageUrl': imageUrl,
        'settings': settings?.toJson(),
        'localeString': localeString,
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
  }

  @override
  String toString() {
    return 'UserLocalProfile: {userID: $userID, userName: $userName, locale: $localeString, isFirstLogin: $isFirstLogin, imageUrl: $imageUrl, $settings, chats: $chats}';
  }
}
