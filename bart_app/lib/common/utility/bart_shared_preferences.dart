import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bart_app/common/entity/user_local_profile.dart';

/// handles all the shared preferences operations
class BartSharedPrefOps {
  static late final SharedPreferences _prefs;

  static const String _userProfileKey = 'BART_USER_PROFILE';

  /// get the shared preferences instance for this app
  static void initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ////////////////////////////////////////////////////////////////////////////////////////////
  // ////////////////////////////////////////////////////////////////////////////////////////////
  // ////////////////////////////////////////////////////////////////////////////////////////////

  static Future<void> saveUserProfile(UserLocalProfile userProfile) async {
    _prefs.setString(_userProfileKey, jsonEncode(userProfile.toJson()));
    debugPrint(
        '------------------------------ SAVED SharedPrefOps: ${_prefs.getString(_userProfileKey)}');
  }

  // ////////////////////////////////////////////////////////////////////////////////////////////
  // ////////////////////////////////////////////////////////////////////////////////////////////
  // ////////////////////////////////////////////////////////////////////////////////////////////

  /// check if a userProfile exists in the shared preferences
  /// (also implies that the user is logged in via the auth provider)
  static bool hasUserProfile() => _prefs.containsKey(_userProfileKey);

  static UserLocalProfile getUserProfile() {
    final String? userProfileStr = _prefs.getString(_userProfileKey);
    if (userProfileStr != null) {
      final map = json.decode(userProfileStr) as Map<String, dynamic>;
      return UserLocalProfile.fromJson(map);
    }
    return UserLocalProfile();
  }

  // ////////////////////////////////////////////////////////////////////////////////////////////
  // ////////////////////////////////////////////////////////////////////////////////////////////
  // ////////////////////////////////////////////////////////////////////////////////////////////

  static void clearUserProfile() {
    debugPrint(
        '------------------------------ CLEARING SharedPrefOps: ${_prefs.getString(_userProfileKey)}');
    _prefs.remove(_userProfileKey);
  }

  // ///////////////////////////////////////////////////////////////////////////
  // ///////////////////////////////////////////////////////////////////////////
  // ///////////////////////////////////////////////////////////////////////////

  static Future<void> clearUnnecessaryData() async {
    // clear all the unnecessary data from the shared preferences
    // this is called when the user logs out or deletes their account
    await _prefs.clear();
    debugPrint('------------------------------ CLEARED SharedPreferences');
  }
}
