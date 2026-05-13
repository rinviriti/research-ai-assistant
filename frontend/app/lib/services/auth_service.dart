class AuthService {
  static String? savedName;
  static String? savedEmail;
  static String? savedPassword;

  static String? currentUser;

  static void registerUser(String name, String email, String password) {
    savedName = name;
    savedEmail = email;
    savedPassword = password;
  }

  static bool loginUser(String email, String password) {
    final isValid = email == savedEmail && password == savedPassword;

    if (isValid) {
      currentUser = savedName;
    }

    return isValid;
  }

  static void logout() {
    currentUser = null;
  }
}
