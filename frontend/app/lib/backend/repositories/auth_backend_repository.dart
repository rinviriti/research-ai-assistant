import '../../services/auth_service.dart';

class AuthBackendRepository {
  Future<bool> login({required String email, required String password}) async {
    return AuthService.loginUser(email, password);
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await AuthService.registerUser(name, email, password);
  }

  Future<void> logout() async {
    await AuthService.logout();
  }

  Future<bool> isLoggedIn() async {
    return AuthService.isLoggedIn();
  }

  String? getCurrentUser() {
    return AuthService.currentUser;
  }
}
