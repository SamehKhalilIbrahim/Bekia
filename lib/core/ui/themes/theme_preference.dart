import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferences {
  static const kPrefKey = "pref_key";

  setTheme(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(kPrefKey, value);
  }

  getTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(kPrefKey) ?? false;
  }
}
