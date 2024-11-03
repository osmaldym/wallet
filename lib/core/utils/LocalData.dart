import 'package:shared_preferences/shared_preferences.dart';

/// Tool to get SharedPreferences data more faster, without call `SharedPreferences.getInstance()`
class LocalData {
    /// Shorthand to get the instance of SharedPreferences.
    /// 
    /// Returns a SharedPreferences intance.
    static Future<SharedPreferences> _getSp() => SharedPreferences.getInstance();

    /// Gets the value from SharedPreferences by `key` identifier.
    /// 
    /// It takes [key], [type] and [def] as parameters and returns a dynamic.
    /// 
    /// - `key`: Key to get the value.
    /// - `type`: To return the datatype you want and accepts by SharedPreferences.
    /// - `def`: To return other data if `key` returns null.
    /// 
    /// Returns the value of setted key.
    static dynamic get(String key, {Type type = Type.str,  dynamic def = null}) async {
      SharedPreferences sp = await _getSp();

      switch (type){
        case Type.obj: return sp.get(key) ?? def;
        case Type.strList: return sp.getStringList(key) ?? def;
        case Type.int: return sp.getInt(key) ?? def;
        case Type.bool: return sp.getBool(key) ?? def;
        default: return sp.getString(key) ?? def;
      }
    }

    /// Sets entry in SharedPreferences by `key` and `value` identifier.
    /// 
    /// It takes [key], [value] and [type] as parameters and returns a dynamic.
    /// 
    /// - `key`: Key identify the entry.
    /// - `value`: Value to set in entry.
    /// - `type`: To return the datatype you want and accepts by SharedPreferences.
    /// 
    /// Returns the value of setted key.
    static dynamic set(String key, dynamic value, {Type type = Type.str}) async {
      SharedPreferences sp = await _getSp();

      switch (type){
        case Type.strList: return sp.setStringList(key, value);
        case Type.int: return sp.setInt(key, value);
        case Type.bool: return sp.setBool(key, value);
        default: return sp.setString(key, value);
      }
    }

    /// Get all setted keys from SharedPreferences persistent storage.
    /// 
    /// Returns a Set of Strings with all keys.
    static Future<Set<String>> keys() async => (await _getSp()).getKeys();

    /// Delete all setted keys from SharedPreferences.
    /// 
    /// Returns a Bool with true when all app preferences has been cleared.
    static Future<bool> clear() async => (await _getSp()).clear();

    /// Delete by key from SharedPreferences an entry.
    /// 
    /// It take [key] as parameter.
    /// 
    /// Returns a Bool with true when the entry has been removed.
    static Future<bool> rem(String key) async => (await _getSp()).remove(key);

    /// Fetches the latest values from the host platform from SharedPreferences.
    /// 
    /// Use this method to observe modifications that were made in native code (without using the plugin) while the app is running.
    static void reload(String key) async => (await _getSp()).reload();

    /// Search if key exists in SharedPreferences.
    /// 
    /// It take [key] as parameter.
    /// 
    /// Returns a Bool with true if the persistent storage contains the given.
    static Future<bool> exists(String key) async => (await _getSp()).containsKey(key);
}

enum Type{
  str,
  bool,
  int,
  strList,
  obj
}