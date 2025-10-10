import 'package:flutter/material.dart';
import 'dart:math';
import '../models/sick_leave_model.dart';
import '../models/reason_model.dart';
import '../services/postgres_service.dart';

class PostgresSickLeaveProvider with ChangeNotifier {
  final PostgresService _postgresService = PostgresService.instance;

  List<SickLeaveModel> _sickLeaves = [];
  List<ReasonModel> _reasons = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<SickLeaveModel> get sickLeaves => _sickLeaves;
  List<ReasonModel> get reasons => _reasons;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> initializeDatabase() async {
    try {
      _isLoading = true;
      notifyListeners();

      await _postgresService.connect();
      print('✅ PostgreSQL database initialized');
    } catch (e) {
      _errorMessage = 'Failed to initialize database: $e';
      print('❌ PostgreSQL initialization failed: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadUserSickLeaves(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _sickLeaves = await _postgresService.getUserSickLeaves(userId);
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

      _reasons = await _postgresService.getAllReasons();
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

      final availableReasons = await _postgresService.getAvailableReasons();

      if (availableReasons.isEmpty) {
        // If no unused reasons, get all reasons
        final allReasons = await _postgresService.getAllReasons();
        if (allReasons.isNotEmpty) {
          final random = Random();
          final selectedReason = allReasons[random.nextInt(allReasons.length)];
          return selectedReason.text;
        }
        return 'Feeling unwell and need to rest at home';
      }

      final random = Random();
      final selectedReason =
          availableReasons[random.nextInt(availableReasons.length)];

      // Mark the reason as used
      await _postgresService.markReasonAsUsed(selectedReason.id);

      return selectedReason.text;
    } catch (e) {
      _errorMessage = 'Failed to generate reason: $e';
      return 'Feeling unwell and need to rest at home'; // Default fallback
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addSickLeave(String userId, String reason) async {
    try {
      _isLoading = true;
      notifyListeners();

      final sickLeave = SickLeaveModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        reason: reason,
        date: DateTime.now(),
        createdAt: DateTime.now(),
      );

      await _postgresService.addSickLeave(sickLeave);

      // Reload the user's sick leaves
      await loadUserSickLeaves(userId);
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
