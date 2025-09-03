import 'package:flutter/material.dart';
import 'dart:math';
import '../models/sick_leave_model.dart';
import '../models/reason_model.dart';
import '../services/firestore_service.dart';

class SickLeaveProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<SickLeaveModel> _sickLeaves = [];
  List<ReasonModel> _reasons = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<SickLeaveModel> get sickLeaves => _sickLeaves;
  List<ReasonModel> get reasons => _reasons;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadUserSickLeaves(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _sickLeaves = await _firestoreService.getUserSickLeaves(userId);
    } catch (e) {
      _errorMessage = 'Failed to load sick leaves: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadReasons() async {
    try {
      _reasons = await _firestoreService.getAllReasons();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load reasons: $e';
      notifyListeners();
    }
  }

  Future<String?> generateRandomReason(String userId) async {
    try {
      final availableReasons = await _firestoreService.getAvailableReasons(
        userId,
      );

      if (availableReasons.isEmpty) {
        // If no unused reasons, get all reasons
        final allReasons = await _firestoreService.getAllReasons();
        if (allReasons.isEmpty) {
          return 'No reasons available';
        }
        final random = Random();
        return allReasons[random.nextInt(allReasons.length)].text;
      }

      final random = Random();
      final selectedReason =
          availableReasons[random.nextInt(availableReasons.length)];

      // Mark reason as used
      await _firestoreService.markReasonAsUsed(selectedReason.id, userId);

      return selectedReason.text;
    } catch (e) {
      _errorMessage = 'Failed to generate reason: $e';
      notifyListeners();
      return null;
    }
  }

  Future<void> addSickLeave(String userId, String reason) async {
    try {
      _isLoading = true;
      notifyListeners();

      final sickLeave = SickLeaveModel(
        id: '',
        userId: userId,
        reason: reason,
        date: DateTime.now(),
        createdAt: DateTime.now(),
      );

      final id = await _firestoreService.addSickLeave(sickLeave);
      final newSickLeave = sickLeave.copyWith(id: id);

      _sickLeaves.insert(0, newSickLeave);

      // Increment user's sick day count
      await _firestoreService.incrementSickDays(userId);
    } catch (e) {
      _errorMessage = 'Failed to add sick leave: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<SickLeaveModel>> getSickLeavesForMonth(
    String userId,
    DateTime month,
  ) async {
    try {
      return await _firestoreService.getUserSickLeavesForMonth(userId, month);
    } catch (e) {
      _errorMessage = 'Failed to load monthly sick leaves: $e';
      notifyListeners();
      return [];
    }
  }

  int getSickLeavesThisMonth(String userId) {
    final now = DateTime.now();
    final thisMonth = DateTime(now.year, now.month);
    final nextMonth = DateTime(now.year, now.month + 1);

    return _sickLeaves.where((leave) {
      return leave.userId == userId &&
          leave.date.isAfter(thisMonth.subtract(const Duration(days: 1))) &&
          leave.date.isBefore(nextMonth);
    }).length;
  }

  int getSickLeavesThisYear(String userId) {
    final now = DateTime.now();
    final thisYear = DateTime(now.year);
    final nextYear = DateTime(now.year + 1);

    return _sickLeaves.where((leave) {
      return leave.userId == userId &&
          leave.date.isAfter(thisYear.subtract(const Duration(days: 1))) &&
          leave.date.isBefore(nextYear);
    }).length;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
