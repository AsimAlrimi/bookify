import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authServiceProvider));
});

class AuthState {
  final bool isAuthenticated;
  final String? role;
  final String? email;
  const AuthState({this.isAuthenticated = false, this.role,  this.email});
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  AuthNotifier(this._authService) : super(const AuthState()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final loggedIn = await _authService.isLoggedIn();
    final role = await _authService.getRole();
    final email = await _authService.getEmail();
    state = AuthState(isAuthenticated: loggedIn, role: role,  email: email);
  }

  Future<void> login(String email, String password) async {
    final success = await _authService.login(email, password);
    if (success) {
      final role = await _authService.getRole();
      state = AuthState(isAuthenticated: true, role: role, email: email);
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    state = const AuthState(isAuthenticated: false);
  }
}