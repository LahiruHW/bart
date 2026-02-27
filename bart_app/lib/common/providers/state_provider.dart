import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bart_app/common/entity/index.dart';
import 'package:bart_app/common/utility/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bart_app/common/constants/enum_login_types.dart';

class BartStateProvider extends ChangeNotifier {
  User? user;
  UserLocalProfile userProfile = UserLocalProfile(settings: UserSettings());
  final authService = BartAuthService();

  Stream<UserLocalProfile>? userProfileStream;

  BartStateProvider() {
    // check shared preferences for user profile, and load if it exists
    if (BartSharedPrefOps.hasUserProfile()) {
      userProfile = BartSharedPrefOps.getUserProfile();
      user = authService.currentUser;
      BartAnalyticsEngine.identify(userProfile, user!.email!);
      debugPrint(
          '-------- StateProvider userProfile uid ${userProfile.userID} loaded from shared prefs');
    }

    // authService.onAuthStateChanged.listen(
    //   (User? newUser) => (newUser != null) ? setUserInstance(newUser) : null,
    // );
    authService.onUserChanged.listen(
      (User? newUser) => (newUser != null) ? setUserInstance(newUser) : null,
    );

    debugPrint('------------------------------ StateProvider initialized');
  }

  /// calls the sign in with google method from the auth service,
  Future<bool> signInWithGoogle() async {
    await authService.signInWithGoogle().then((userCred) async {
      await setupUserAccount(userCred);
      await BartAnalyticsEngine.identify(userProfile, userCred.user!.email!);
      return true;
    }).onError(
      (error, stackTrace) {
        debugPrint(error.toString());
        return false;
      },
    );
    return true;
  }

  Future<bool> deleteAccount() async {
    if (authService.currentUser != null) {
      debugPrint(
          '--------------------- StateProvider user is deleting account');
      await authService
          .deleteAccount()
          .then(
            (_) => clearUserInstance(),
          )
          .onError(
            (error, stackTrace) => throw Exception(error),
          );
      return true;
    } else if (authService.currentUser == null) {
      debugPrint('--------------------- StateProvider user is already deleted');
      clearUserInstance();
      return true;
    } else {
      return false;
    }
  }

  /// sets up the user account using the usercredential object
  Future<void> setupUserAccount(UserCredential userCred) async {
    debugPrint('|||||||||||||||||||||||||||||||||||||||||||  ${userCred.user}');
    final dataMap = await BartFirestoreServices.setupUserProfile(
      userCred.user!.uid,
      null,
      userCred.user!.photoURL!,
      loginType: LoginType.google,
    );
    // userProfile = dataMap['userProfile'] as UserLocalProfile;
    final fetchedUserProfile = dataMap['userProfile'] as UserLocalProfile;
    userProfile =
        UserLocalProfile.mergeCurrentSettings(userProfile, fetchedUserProfile);
    BartSharedPrefOps.saveUserProfile(userProfile);
    notifyListeners();
  }

  /// set all the user instance data after login or signup
  void setUserInstance(User user) async {
    this.user = user;
    debugPrint('------------------------------ StateProvider user set');
    notifyListeners();
  }

  /// clear the user instance and all user data after sign out
  void clearUserInstance() async {
    user = null;
    final tempUserProfile = UserLocalProfile(settings: UserSettings());
    userProfile =
        UserLocalProfile.mergeCurrentSettings(userProfile, tempUserProfile);

    // clear sharedpref and image cache
    BartSharedPrefOps.clearUserProfile();
    BartImageTools.customCacheManager.emptyCache();

    debugPrint('-------------------- StateProvider user & userProfile cleared');
    notifyListeners();
  }

  /// refresh the user instance data after a change in the user profile
  void refreshUserInstance() async {
    throw UnimplementedError();
  }

  /// sign out the current user instance
  Future<bool> signOut() async {
    if (authService.currentUser != null) {
      debugPrint('--------------------- StateProvider user signing out');
      await authService.signOut().then(
        (value) {
          // BartAnalyticsEngine.userLogsOutAE();
          clearUserInstance();
        },
      ).onError(
        (error, stackTrace) => throw Exception(error),
      );
      return true;
    } else if (authService.currentUser == null) {
      debugPrint('--------------------- StateProvider user already signed out');
      clearUserInstance();
      return true;
    } else {
      return false;
    }
  }

  /// switch the user's locale and update the user profile
  void switchLocale(String localeString, BuildContext context) {
    debugPrint(
        '--------------------- StateProvider userProfile locale switched to $localeString');
    userProfile.updateLocaleString(localeString);
    final currentLocale = userProfile.localeFromString(localeString);
    context.setLocale(currentLocale);
    BartSharedPrefOps.saveUserProfile(userProfile);
    // handling setting changes when user is logged out
    if (userProfile.userID.isNotEmpty) {
      // BartFirestoreServices.updateUserProfileLocale(userProfile.userID, localeString);
      BartFirestoreServices.updateUserProfile(userProfile);
    }
    notifyListeners();
  }

  /// check if the user name exists in the firestore database
  Future<bool> doesUserNameExist(String userName) async {
    return await BartFirestoreServices.doesUserNameExist(userName);
  }

  /// check if the full name exists in the firestore database
  Future<bool> doesFullNameExist(String fullName) async {
    return await BartFirestoreServices.doesFullNameExist(fullName);
  }

  /// update the user's local profile userName and update the user Profile
  Future<void> updateUserName(String newUserName) async {
    userProfile.userName = newUserName;
    BartSharedPrefOps.saveUserProfile(userProfile);
    // handling setting changes when user is logged out
    if (userProfile.userID.isNotEmpty) {
      await BartFirestoreServices.updateUserProfile(userProfile);
    }
    notifyListeners();
  }

  /// update the user's local profile userName and update the user Profile
  Future<void> updateFullName(String newFullName) async {
    userProfile.fullName = newFullName;
    BartSharedPrefOps.saveUserProfile(userProfile);
    // handling setting changes when user is logged out
    if (userProfile.userID.isNotEmpty) {
      await BartFirestoreServices.updateUserProfile(userProfile);
    }
    notifyListeners();
  }

  Future<void> updateUserProfile(UserLocalProfile newProfile) async {
    userProfile = newProfile;
    BartSharedPrefOps.saveUserProfile(userProfile);
    // handling setting changes when user is logged out
    if (userProfile.userID.isNotEmpty) {
      await BartFirestoreServices.updateUserProfile(userProfile);
    }
    notifyListeners();
  }

  /// update the user's local profile data via the state provider
  void updateSettings({
    bool? isDarkMode,
    bool? isLegacyUI,
    String? userName,
    String? imageUrl,
  }) {
    userProfile.settings!.updateSettings(
      isDarkMode: isDarkMode,
      isLegacyUI: isLegacyUI,
    );

    // update the userProfile in the shared preferences also
    BartSharedPrefOps.saveUserProfile(userProfile);

    // handling setting changes when user is logged out
    if (userProfile.userID.isNotEmpty) {
      BartFirestoreServices.updateUserProfileSettings(
        userProfile.userID,
        userProfile.settings!,
      );
    }
    notifyListeners();
  }
}
