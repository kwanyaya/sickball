import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/postgres_auth_provider.dart';
import '../providers/postgres_sick_leave_provider.dart';
import '../models/sick_leave_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    try {
      final authProvider = Provider.of<PostgresAuthProvider>(
        context,
        listen: false,
      );
      final sickLeaveProvider = Provider.of<PostgresSickLeaveProvider>(
        context,
        listen: false,
      );

      if (authProvider.user != null) {
        sickLeaveProvider.loadUserSickLeaves(authProvider.user!.uid);
      }
    } catch (e) {
      // Handle provider not found error gracefully
      print('Provider not found in DashboardScreen: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Statistics Cards
            Consumer<PostgresAuthProvider>(
              builder: (context, authProvider, child) {
                return Consumer<PostgresSickLeaveProvider>(
                  builder: (context, sickLeaveProvider, child) {
                    if (authProvider.user == null) {
                      return const Center(child: Text('User not found'));
                    }

                    final userId = authProvider.user!.uid;
                    final thisMonth = sickLeaveProvider.getSickLeavesThisMonth(
                      userId,
                    );
                    final thisYear = sickLeaveProvider.getSickLeavesThisYear(
                      userId,
                    );
                    final total = authProvider.userModel?.totalSickDays ?? 0;

                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                'This Month',
                                thisMonth.toString(),
                                Icons.calendar_month,
                                Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildStatCard(
                                'This Year',
                                thisYear.toString(),
                                Icons.calendar_today,
                                Colors.orange,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildStatCard(
                          'Total Sick Days',
                          total.toString(),
                          Icons.sick,
                          Colors.purple,
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 24),

            // Recent Sick Leaves
            Text(
              'Recent Sick Leaves',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),

            Consumer<PostgresSickLeaveProvider>(
              builder: (context, sickLeaveProvider, child) {
                if (sickLeaveProvider.isLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (sickLeaveProvider.sickLeaves.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No sick leaves recorded yet',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start by generating your first sick leave reason!',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children:
                      sickLeaveProvider.sickLeaves
                          .take(10) // Show only recent 10
                          .map((sickLeave) => _buildSickLeaveCard(sickLeave))
                          .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color? color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color?.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSickLeaveCard(SickLeaveModel sickLeave) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.red[400],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                DateFormat('MMM dd, yyyy').format(sickLeave.date),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const Spacer(),
              Text(
                DateFormat('HH:mm').format(sickLeave.createdAt),
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            sickLeave.reason,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
