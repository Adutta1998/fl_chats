import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static String userIdKey = "USERID";
  static String userNameKey = "USERNAME";
  static String userDisplayNameKey = "USERDISPLAYNAME";
  static String userEmailKey = "USEREMAIL";
  static String userProfilePictureUrlKey = "USERPROFILEPICTUREURL";

  // Setters
  Future<bool> saveUserId(String userid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userIdKey, userid);
  }

  Future<bool> saveUserName(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userNameKey, username);
  }

  Future<bool> saveUserDisplayName(String userdisplayname) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userDisplayNameKey, userdisplayname);
  }

  Future<bool> saveUserEmail(String useremail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userEmailKey, useremail);
  }

  Future<bool> saveUserProfilePictureUrl(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userProfilePictureUrlKey, url);
  }

// Getters

  Future<String> getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey)!;
  }

  Future<String> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey)!;
  }

  Future<String> getUserDisplayName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userDisplayNameKey)!;
  }

  Future<String> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey)!;
  }

  Future<String> getUserProfilePictureUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userProfilePictureUrlKey)!;
  }
}
