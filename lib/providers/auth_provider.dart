import 'package:flutter/material.dart';

// Mock classes for testing
class MockUser {
  String get uid => 'test_user_123';
  String? get email => 'test@example.com';
  String? get displayName => 'Test User';
}

class MockUserModel {
  String get uid => 'test_user_123';
  String get email => 'test@example.com';
  String get name => 'Test User';
  int get totalSickDays => 0;
  DateTime get createdAt => DateTime.now();
}

class AuthProvider with ChangeNotifier {
  // Minimal implementation without Firebase for testing
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Mock user object for compatibility
  dynamic get user => _isAuthenticated ? MockUser() : null;
  dynamic get userModel => _isAuthenticated ? MockUserModel() : null;
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
