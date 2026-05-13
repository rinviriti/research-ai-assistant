class AuthService {
  static String? savedEmail;
  static String? savedPassword;

  static void registerUser(String email, String password) {
    savedEmail = email;
    savedPassword = password;
  }

  static bool loginUser(String email, String password) {
    return email == savedEmail && password == savedPassword;
  }
}
