import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  User? _user;
  UserModel? _userModel;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _authService.authStateChanges.listen((User? user) {
      _user = user;
      if (user != null) {
        _loadUserModel();
      } else {
        _userModel = null;
      }
      notifyListeners();
    });
  }

  Future<void> _loadUserModel() async {
    if (_user == null) return;

    try {
      _userModel = await _firestoreService.getUser(_user!.uid);
      if (_userModel == null) {
        // Create new user model if doesn't exist
        _userModel = UserModel(
          uid: _user!.uid,
          email: _user!.email ?? '',
          name: _user!.displayName ?? '',
          totalSickDays: 0,
          createdAt: DateTime.now(),
        );
        await _firestoreService.createUser(_userModel!);
      }

      // Initialize default reasons after user is loaded (safe timing)
      // TODO: Re-enable this after fixing memory issues
      // await _initializeDefaultReasonsIfNeeded();

      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load user data: $e';
      notifyListeners();
    }
  }

  Future<void> _initializeDefaultReasonsIfNeeded() async {
    try {
      await _firestoreService.initializeDefaultReasons();
      print('Default reasons initialized successfully');
    } catch (e) {
      print('Error initializing default reasons: $e');
      // Don't throw here - this is not critical for app functionality
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final userCredential = await _authService.signInWithGoogle();
      if (userCredential != null) {
        _user = userCredential.user;
        await _loadUserModel();
      }
    } catch (e) {
      _errorMessage = 'Sign in failed: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      _isLoading = true;
      notifyListeners();

      await _authService.signOut();
      _user = null;
      _userModel = null;
    } catch (e) {
      _errorMessage = 'Sign out failed: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
