import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? _prefsInstance;
  static final Future<SharedPreferences> prefsData = SharedPreferences.getInstance();

  // Initialize SharedPreferences for synchronous access
  static Future<void> init() async {
    _prefsInstance = await SharedPreferences.getInstance();
  }

  // Synchronous getters/setters (for use after init)
  static bool getBool(String key, {bool defaultValue = false}) {
    return _prefsInstance?.getBool(key) ?? defaultValue;
  }

  static Future<void> setBool(String key, bool value) async {
    final SharedPreferences prefs = await prefsData;
    await prefs.setBool(key, value);

    // Also update in-memory instance
    if (_prefsInstance != null) {
      await _prefsInstance!.setBool(key, value);
    }
  }

  static String getString(String key, {String defaultValue = ''}) {
    return _prefsInstance?.getString(key) ?? defaultValue;
  }

  static Future<void> setString(String key, String value) async {
    final SharedPreferences prefs = await prefsData;
    await prefs.setString(key, value);

    // Also update in-memory instance
    if (_prefsInstance != null) {
      await _prefsInstance!.setString(key, value);
    }
  }

  // Synchronous version of getLogin
  static bool getLoginSync() {
    return _prefsInstance?.getBool("isLogin") ?? false;
  }

  // Original async methods
  static Future<void> setLogin(bool isLogin) async {
    final SharedPreferences prefs = await prefsData;
    await prefs.setBool("isLogin", isLogin);

    // Also update in-memory instance
    if (_prefsInstance != null) {
      await _prefsInstance!.setBool("isLogin", isLogin);
    }
  }

  static Future<bool> getLogin() async {
    final SharedPreferences prefs = await prefsData;
    return prefs.getBool("isLogin") ?? false;
  }

  static Future<void> setToken(String isToken) async {
    final SharedPreferences prefs = await prefsData;
    await prefs.setString("isToken", isToken);
  }

  static Future<String> getToken() async {
    final SharedPreferences prefs = await prefsData;
    return prefs.getString("isToken") ?? '';
  }

  static Future<void> setId(String isId) async {
    final SharedPreferences prefs = await prefsData;
    await prefs.setString("isId", isId);
  }

  static Future<String> getId() async {
    final SharedPreferences prefs = await prefsData;
    return prefs.getString("isId") ?? '';
  }

  static prefsDataClear() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
}
