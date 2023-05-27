import 'package:shared_preferences/shared_preferences.dart';

class Helper {
  static String sharedPreferenceUserenameKey = "USEREMAILKEY";
  static String sharedPreferenceuserLoggedIn = "USERLOGGEDINKEY";

  //save data

  static Future<bool> saveUsernameSharedPreference(String userName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceUserenameKey, userName);
  }

  static Future<bool> saveUserloggedInSharedPreference(
      bool userLoggedIn) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(
        sharedPreferenceuserLoggedIn, userLoggedIn);
  }

  

//fetch data
  static Future<String?> getUsernameSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceUserenameKey);
  }

  static Future<bool?> getUserLoggedInSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(sharedPreferenceuserLoggedIn);
  }


}