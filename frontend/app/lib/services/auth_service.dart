class AuthService {
  static String? currentUser;
  static String? currentEmail;

  static final List<Map<String, String>> users = [];

  static Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final alreadyExists = users.any((user) => user["email"] == email);

    if (alreadyExists) {
      return false;
    }

    users.add({"name": name, "email": email, "password": password});

    currentUser = name;
    currentEmail = email;

    return true;
  }

  static Future<bool> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final user = users.firstWhere(
        (user) => user["email"] == email && user["password"] == password,
      );

      currentUser = user["name"];
      currentEmail = user["email"];

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> logout() async {
    currentUser = null;
    currentEmail = null;
  }

  static bool isLoggedIn() {
    return currentUser != null;
  }
}
