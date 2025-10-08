import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  // Minimal implementation without Firebase for testing
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Placeholder getters for compatibility
  dynamic get user => null;
  dynamic get userModel => null;

  AuthProvider() {
    // No Firebase initialization in constructor
  }

  // Placeholder methods for testing
  Future<void> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    // Simulate sign-in for testing
    await Future.delayed(const Duration(seconds: 1));
    _isAuthenticated = true;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    _isAuthenticated = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
