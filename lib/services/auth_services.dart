import 'database_helper.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

class AuthService {
  final DatabaseHelper _db = DatabaseHelper();

  // Store the currently logged-in user
  static Map<String, dynamic>? _currentUser;

  Map<String, dynamic>? get currentUser => _currentUser;

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
        _currentUser = user; // ✅ store globally
        print("Login success -> $user");
        return user;          // return user map
      } else {
        throw AuthException("Invalid email or password!");
      }
    } catch (e) {
      print("Database error during login: $e");
      throw AuthException("Database connection failed");
    }
  }

  void logout() {
    _currentUser = null;
    print("User logged out");
  }

  String? getUserEmail() => _currentUser?['email'];
}

// Global instance
final AuthService authService = AuthService();
