import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtilityNew {
  SharedPreferencesUtilityNew._internal();
  static final SharedPreferencesUtilityNew _instance = SharedPreferencesUtilityNew._internal();
  factory SharedPreferencesUtilityNew() => _instance;

  static SharedPreferences? _sharedPreferences;
  Future<SharedPreferences> get sharedPreferences async => _sharedPreferences ??= await SharedPreferences.getInstance();

  Future<bool> write({required String key, required dynamic value}) async {
    final SharedPreferences p = await _instance.sharedPreferences;

    switch (value.runtimeType) {
      case const (bool):
        return p.setBool(key, value);
      case const (double):
        return p.setDouble(key, value);
      case const (int):
        return p.setInt(key, value);
      case const (String):
        return p.setString(key, value);
      default:
        return false;
    }
  }

  Future<dynamic> read({required String key}) async {
    final SharedPreferences p = await _instance.sharedPreferences;
    return p.get(key);
  }

  Future<bool> delete({required String key}) async {
    final SharedPreferences p = await _instance.sharedPreferences;
    return p.remove(key);
  }

  Future<bool> clear() async {
    final SharedPreferences p = await _instance.sharedPreferences;
    return p.clear();
  }
}
