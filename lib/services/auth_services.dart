import 'database_helper.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

class AuthService {
  final DatabaseHelper _db = DatabaseHelper();

  get currentUser => null;

  // Register
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await _db.registerUser(name, email, password);
      print("Registration success -> Name: $name, Email: $email");
      return true;
    } catch (e) {
      print("Database error during registration: $e");
      throw AuthException("Email already exists or database error!");
    }
  }

  // Login
  Future<Map<String, dynamic>?> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _db.loginUser(email, password);
      if (user != null) {
        print("Login success -> $user");
        return user;
      } else {
        throw AuthException("Invalid email or password!");
      }
    } catch (e) {
      print("Database error during login: $e");
      throw AuthException("Database connection failed");
    }
  }

  void logout() {
    print("User logged out");
  }

  getUserEmail() {}
}

// Global instance
final AuthService authService = AuthService();
