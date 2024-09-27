import 'package:apiauth/auth/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  AuthProvider() {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    _isLoggedIn = await _authService.isLoggedIn();
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    final success = await _authService.login(email, password);
    if (success) {
      _isLoggedIn = true;
      notifyListeners();
    }
    return success;
  }

  Future<bool> signUp(String email, String password, String firstName,
      String lastName, String DOB, String idImage, String phone) async {
    final success = await _authService.signUp(
        email, password, firstName, lastName, DOB, idImage, phone);
    if (success) {
      _isLoggedIn = true;
      notifyListeners();
    }
    return success;
  }

  Future<void> logout() async {
    await _authService.logout();
    _isLoggedIn = false;
    notifyListeners();
  }
}
