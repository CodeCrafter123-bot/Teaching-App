import 'dart:async';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
  @override
  String toString() => message;
}

class User {
  final String id;
  final String name;
  final String email;
  User({required this.id, required this.name, required this.email});
}

class AuthService {
  // In-memory "database"
  final Map<String, Map<String, String>> _users = {};
  User? _currentUser;

  User? get currentUser => _currentUser;

  // Get current logged-in email
  String? getUserEmail() {
    return _currentUser?.email;
  }

  // Register a new user (mock)
  Future<User> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final normalized = email.trim().toLowerCase();
    if (!_isEmail(normalized)) {
      throw AuthException('Please enter a valid email address.');
    }
    if (name.trim().length < 2) {
      throw AuthException('Name should be at least 2 characters.');
    }
    if (password.length < 6) {
      throw AuthException('Password must be at least 6 characters.');
    }
    if (_users.containsKey(normalized)) {
      throw AuthException('An account with this email already exists.');
    }
    _users[normalized] = {'name': name.trim(), 'password': password};
    _currentUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name.trim(),
      email: normalized,
    );
    return _currentUser!;
  }

  // Login (mock)
  Future<User> login({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final normalized = email.trim().toLowerCase();
    if (!_isEmail(normalized)) {
      throw AuthException('Please enter a valid email address.');
    }
    if (!_users.containsKey(normalized)) {
      throw AuthException('No account found for this email.');
    }
    if (_users[normalized]!['password'] != password) {
      throw AuthException('Incorrect password. Please try again.');
    }
    final name = _users[normalized]!['name']!;
    _currentUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: normalized,
    );
    return _currentUser!;
  }

  void logout() {
    _currentUser = null;
  }

  bool _isEmail(String v) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return regex.hasMatch(v);
  }
}

// Single shared instance for the whole app
final authService = AuthService();
