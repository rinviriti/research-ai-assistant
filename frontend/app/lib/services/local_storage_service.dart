import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static Future<void> saveString({
    required String key,
    required String value,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(key);
  }

  static Future<void> saveJson({
    required String key,
    required dynamic data,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final encoded = jsonEncode(data);

    await prefs.setString(key, encoded);
  }

  static Future<dynamic> getJson(String key) async {
    final prefs = await SharedPreferences.getInstance();

    final raw = prefs.getString(key);

    if (raw == null) return null;

    return jsonDecode(raw);
  }

  static Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(key);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();
  }
}
