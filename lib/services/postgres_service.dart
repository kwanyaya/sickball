import 'package:postgres/postgres.dart';
import '../models/user_model.dart';
import '../models/sick_leave_model.dart';
import '../models/reason_model.dart';

class PostgresService {
  static PostgresService? _instance;
  late Connection _connection;

  PostgresService._();

  static PostgresService get instance {
    _instance ??= PostgresService._();
    return _instance!;
  }

  Future<void> connect() async {
    try {
      _connection = await Connection.open(
        Endpoint(
          host: 'localhost',
          port: 5432,
          database: 'sickball_dev',
          username: 'tony_sagebook', // Default postgres user
          // password: 'your_password', // Add if you set a password
        ),
        settings: const ConnectionSettings(sslMode: SslMode.disable),
      );

      // Create tables if they don't exist
      await _createTables();
      await _insertDefaultReasons();

      print('✅ Connected to PostgreSQL successfully');
    } catch (e) {
      print('❌ Failed to connect to PostgreSQL: $e');
      rethrow;
    }
  }

  Future<void> _createTables() async {
    // Users table
    await _connection.execute('''
      CREATE TABLE IF NOT EXISTS users (
        uid VARCHAR(255) PRIMARY KEY,
        email VARCHAR(255) NOT NULL UNIQUE,
        name VARCHAR(255) NOT NULL,
        total_sick_days INTEGER DEFAULT 0,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Reasons table
    await _connection.execute('''
      CREATE TABLE IF NOT EXISTS reasons (
        id SERIAL PRIMARY KEY,
        description TEXT NOT NULL,
        category VARCHAR(100),
        is_used BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Sick leaves table
    await _connection.execute('''
      CREATE TABLE IF NOT EXISTS sick_leaves (
        id SERIAL PRIMARY KEY,
        user_id VARCHAR(255) REFERENCES users(uid) ON DELETE CASCADE,
        reason TEXT NOT NULL,
        date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    print('✅ Database tables created/verified');
  }

  Future<void> _insertDefaultReasons() async {
    // Check if reasons already exist
    final result = await _connection.execute('SELECT COUNT(*) FROM reasons');
    final count = result.first.first as int;

    if (count == 0) {
      final defaultReasons = [
        "Feeling unwell and need to rest at home",
        "Experiencing flu-like symptoms including fever and fatigue",
        "Dealing with a stomach bug and digestive issues",
        "Suffering from a severe migraine headache",
        "Food poisoning from last night's dinner",
        "Caught a cold and have congestion",
        "Back pain preventing normal movement",
        "Dental emergency requiring immediate attention",
        "Eye infection causing vision problems",
        "Allergic reaction requiring medical monitoring",
        "Family emergency requiring immediate attention",
        "Medical appointment that couldn't be scheduled outside work hours",
        "Recovering from a minor injury",
        "Experiencing severe stress and mental health day needed",
        "Childcare emergency - babysitter cancelled last minute",
      ];

      for (final reason in defaultReasons) {
        await _connection.execute(
          'INSERT INTO reasons (description, category) VALUES (\$1, \$2)',
          parameters: [reason, 'general'],
        );
      }

      print('✅ Default reasons inserted');
    }
  }

  // User operations
  Future<void> createUser(UserModel user) async {
    await _connection.execute(
      'INSERT INTO users (uid, email, name, total_sick_days, created_at) VALUES (\$1, \$2, \$3, \$4, \$5) ON CONFLICT (uid) DO NOTHING',
      parameters: [
        user.uid,
        user.email,
        user.name,
        user.totalSickDays,
        user.createdAt,
      ],
    );
  }

  Future<UserModel?> getUser(String uid) async {
    final result = await _connection.execute(
      'SELECT uid, email, name, total_sick_days, created_at FROM users WHERE uid = \$1',
      parameters: [uid],
    );

    if (result.isEmpty) return null;

    final row = result.first;
    return UserModel(
      uid: row[0] as String,
      email: row[1] as String,
      name: row[2] as String,
      totalSickDays: row[3] as int,
      createdAt: row[4] as DateTime,
    );
  }

  // Reason operations
  Future<List<ReasonModel>> getAllReasons() async {
    final result = await _connection.execute(
      'SELECT id, description, category FROM reasons ORDER BY created_at DESC',
    );

    return result
        .map(
          (row) => ReasonModel(
            id: row[0].toString(),
            text: row[1] as String,
            category: row[2] as String? ?? 'general',
          ),
        )
        .toList();
  }

  Future<List<ReasonModel>> getAvailableReasons() async {
    final result = await _connection.execute(
      'SELECT id, description, category FROM reasons WHERE is_used = FALSE ORDER BY RANDOM() LIMIT 10',
    );

    return result
        .map(
          (row) => ReasonModel(
            id: row[0].toString(),
            text: row[1] as String,
            category: row[2] as String? ?? 'general',
          ),
        )
        .toList();
  }

  Future<void> markReasonAsUsed(String reasonId) async {
    await _connection.execute(
      'UPDATE reasons SET is_used = TRUE WHERE id = \$1',
      parameters: [int.parse(reasonId)],
    );
  }

  // Sick leave operations
  Future<void> addSickLeave(SickLeaveModel sickLeave) async {
    await _connection.execute(
      'INSERT INTO sick_leaves (user_id, reason, date) VALUES (\$1, \$2, \$3)',
      parameters: [sickLeave.userId, sickLeave.reason, sickLeave.date],
    );

    // Update user's total sick days
    await _connection.execute(
      'UPDATE users SET total_sick_days = total_sick_days + 1 WHERE uid = \$1',
      parameters: [sickLeave.userId],
    );
  }

  Future<List<SickLeaveModel>> getUserSickLeaves(String userId) async {
    final result = await _connection.execute(
      'SELECT id, user_id, reason, date, created_at FROM sick_leaves WHERE user_id = \$1 ORDER BY date DESC',
      parameters: [userId],
    );

    return result
        .map(
          (row) => SickLeaveModel(
            id: row[0].toString(),
            userId: row[1] as String,
            reason: row[2] as String,
            date: row[3] as DateTime,
            createdAt: row[4] as DateTime,
          ),
        )
        .toList();
  }

  Future<int> getUserSickLeavesCount(
    String userId,
    DateTime start,
    DateTime end,
  ) async {
    final result = await _connection.execute(
      'SELECT COUNT(*) FROM sick_leaves WHERE user_id = \$1 AND date BETWEEN \$2 AND \$3',
      parameters: [userId, start, end],
    );

    return result.first.first as int;
  }

  Future<void> disconnect() async {
    await _connection.close();
  }
}
