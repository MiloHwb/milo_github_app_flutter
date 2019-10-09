import 'package:shared_preferences/shared_preferences.dart';

///SharedPreferences本地存储
class LocalStorage {
  static save(String key, dynamic value) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static dynamic get(String key) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }

  static remove(String key) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
