import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/postgres_service.dart';

// Mock classes for testing
class MockUser {
  String get uid => 'postgres_user_123';
  String? get email => 'postgres@example.com';
  String? get displayName => 'PostgreSQL User';
}

class PostgresAuthProvider with ChangeNotifier {
  final PostgresService _postgresService = PostgresService.instance;

  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _errorMessage;
  UserModel? _userModel;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Mock user object for compatibility
  dynamic get user => _isAuthenticated ? MockUser() : null;
  UserModel? get userModel => _userModel;

  PostgresAuthProvider() {
    // Initialize PostgreSQL connection when provider is created
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    try {
      await _postgresService.connect();
      print('✅ PostgreSQL Auth Provider initialized');
    } catch (e) {
      print('❌ PostgreSQL Auth Provider initialization failed: $e');
      _errorMessage = 'Database connection failed: $e';
      notifyListeners();
    }
  }

  // Simulate sign-in and create/load user in PostgreSQL
  Future<void> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate sign-in delay
      await Future.delayed(const Duration(seconds: 1));

      _isAuthenticated = true;

      // Create/load user in PostgreSQL
      await _loadOrCreateUser();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Sign in failed: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadOrCreateUser() async {
    try {
      final mockUser = MockUser();

      // Try to load existing user
      _userModel = await _postgresService.getUser(mockUser.uid);

      if (_userModel == null) {
        // Create new user if doesn't exist
        _userModel = UserModel(
          uid: mockUser.uid,
          email: mockUser.email ?? '',
          name: mockUser.displayName ?? '',
          totalSickDays: 0,
          createdAt: DateTime.now(),
        );

        await _postgresService.createUser(_userModel!);
        print('✅ New user created in PostgreSQL');
      } else {
        print('✅ Existing user loaded from PostgreSQL');
      }
    } catch (e) {
      print('❌ Failed to load/create user: $e');
      _errorMessage = 'Failed to load user data: $e';
    }
  }

  Future<void> signOut() async {
    _isAuthenticated = false;
    _userModel = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _postgresService.disconnect();
    super.dispose();
  }
}
