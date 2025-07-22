import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _tokenKey = 'auth_token';
  static const _roleKey = 'auth_role';
  static const _emailKey = 'auth_email';

  // Mocked credentials (can be replaced with Firebase Auth later)
  final Map<String, String> _users = {
    'user@example.com': 'password123',
    'admin@example.com': 'admin123',
  };

  Future<bool> login(String email, String password) async {
    if (_users[email] == password) {
      final prefs = await SharedPreferences.getInstance();
      final role = email.contains('admin') ? 'admin' : 'user';
      await prefs.setString(_tokenKey, 'mocked_token');
      await prefs.setString(_roleKey, role);
      await prefs.setString(_emailKey, email); 
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_roleKey);
    await prefs.remove(_emailKey);
  }

  Future<String?> getEmail() async { 
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_tokenKey);
  }

  Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey);
  }
}