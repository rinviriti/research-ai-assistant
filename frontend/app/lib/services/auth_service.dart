import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static String? currentUser;
  static String? currentUserEmail;

  static const String nameKey = "rh_user_name";
  static const String emailKey = "rh_user_email";
  static const String passwordKey = "rh_user_password";
  static const String loggedInKey = "rh_logged_in";

  static Future<void> registerUser(
    String name,
    String email,
    String password,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(nameKey, name.trim());
    await prefs.setString(emailKey, email.trim().toLowerCase());
    await prefs.setString(passwordKey, password);
    await prefs.setBool(loggedInKey, true);

    currentUser = name.trim();
    currentUserEmail = email.trim().toLowerCase();
  }

  static Future<bool> loginUser(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();

    final storedEmail = prefs.getString(emailKey);
    final storedPassword = prefs.getString(passwordKey);
    final storedName = prefs.getString(nameKey);

    final isValid =
        email.trim().toLowerCase() == storedEmail && password == storedPassword;

    if (isValid) {
      currentUser = storedName;
      currentUserEmail = storedEmail;
      await prefs.setBool(loggedInKey, true);
    }

    return isValid;
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();

    final loggedIn = prefs.getBool(loggedInKey) ?? false;

    currentUser = prefs.getString(nameKey);
    currentUserEmail = prefs.getString(emailKey);

    return loggedIn && currentUser != null && currentUserEmail != null;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(loggedInKey, false);

    currentUser = null;
    currentUserEmail = null;
  }

  static Future<void> deleteAccount() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(nameKey);
    await prefs.remove(emailKey);
    await prefs.remove(passwordKey);
    await prefs.remove(loggedInKey);

    currentUser = null;
    currentUserEmail = null;
  }
}
