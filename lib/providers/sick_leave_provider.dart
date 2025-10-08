import 'package:flutter/material.dart';
import 'dart:math';

class SickLeaveProvider with ChangeNotifier {
  List<dynamic> _sickLeaves = [];
  List<String> _reasons = [
    'Feeling unwell',
    'Flu symptoms',
    'Stomach bug',
    'Migraine',
    'Food poisoning',
  ];
  bool _isLoading = false;
  String? _errorMessage;

  List<dynamic> get sickLeaves => _sickLeaves;
  List<String> get reasons => _reasons;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadUserSickLeaves(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Simulate loading
      await Future.delayed(const Duration(milliseconds: 500));
      _sickLeaves = []; // Empty list for now
    } catch (e) {
      _errorMessage = 'Failed to load sick leaves: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadReasons() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Simulate loading - reasons are already initialized
      await Future.delayed(const Duration(milliseconds: 300));
    } catch (e) {
      _errorMessage = 'Failed to load reasons: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> generateReason(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Simulate generation
      await Future.delayed(const Duration(milliseconds: 800));
      final random = Random();
      final selectedReason = _reasons[random.nextInt(_reasons.length)];

      return selectedReason;
    } catch (e) {
      _errorMessage = 'Failed to generate reason: $e';
      return 'Feeling unwell'; // Default fallback
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> addSickLeave(String userId, String reason) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Simulate adding sick leave
      await Future.delayed(const Duration(milliseconds: 500));

      // Create a mock sick leave entry
      final sickLeave = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'userId': userId,
        'reason': reason,
        'date': DateTime.now(),
      };

      _sickLeaves.add(sickLeave);
    } catch (e) {
      _errorMessage = 'Failed to add sick leave: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> generateRandomReason(String userId) async {
    return await generateReason(userId);
  }

  int getSickLeavesThisMonth(String userId) {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);

    return _sickLeaves.where((sickLeave) {
      return sickLeave.date.isAfter(
            firstDayOfMonth.subtract(const Duration(days: 1)),
          ) &&
          sickLeave.date.isBefore(now.add(const Duration(days: 1)));
    }).length;
  }

  int getSickLeavesThisYear(String userId) {
    final now = DateTime.now();
    final firstDayOfYear = DateTime(now.year, 1, 1);

    return _sickLeaves.where((sickLeave) {
      return sickLeave.date.isAfter(
            firstDayOfYear.subtract(const Duration(days: 1)),
          ) &&
          sickLeave.date.isBefore(now.add(const Duration(days: 1)));
    }).length;
  }
}
