import 'package:shared_preferences/shared_preferences.dart';

import '../models/session_user_model.dart';

class SessionService {
  static SessionUserModel? currentUser;

  static const String sessionKey = "rh_session_user";

  static Future<void> saveSession(SessionUserModel user) async {
    final prefs = await SharedPreferences.getInstance();

    currentUser = user;

    await prefs.setString(sessionKey, user.toJson().toString());
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();

    currentUser = null;

    await prefs.remove(sessionKey);
  }
}
