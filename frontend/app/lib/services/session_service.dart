import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/session_user_model.dart';

class SessionService {
  static SessionUserModel? currentUser;

  static const String sessionKey = "rh_session_user";

  static Future<void> saveSession(SessionUserModel user) async {
    final prefs = await SharedPreferences.getInstance();

    currentUser = user;

    await prefs.setString(sessionKey, jsonEncode(user.toJson()));
  }

  static Future<SessionUserModel?> loadSession() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(sessionKey);

    if (data == null || data.isEmpty) {
      currentUser = null;
      return null;
    }

    currentUser = SessionUserModel.fromJson(
      Map<String, dynamic>.from(jsonDecode(data)),
    );

    return currentUser;
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();

    currentUser = null;

    await prefs.remove(sessionKey);
  }

  static bool get isLoggedIn {
    return currentUser != null;
  }
}
