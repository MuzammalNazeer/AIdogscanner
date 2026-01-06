
import '../database/DatabaseHelper.dart';
import 'User.dart';

class AuthService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Check if user exists by email or username
  Future<Map<String, dynamic>?> checkUserExists(String email, String username) async {
    final db = await _dbHelper.database;

    final users = await db.query(
      _dbHelper.tableUsers,
      where: '${_dbHelper.colEmail} = ? OR ${_dbHelper.colUsername} = ?',
      whereArgs: [email, username],
    );

    return users.isNotEmpty ? users.first : null;
  }

  // Register new user
  Future<Map<String, dynamic>> registerUser({
    required String username,
    required String email,
    required String password,
    required String fullName,
  }) async {
    // Check if user already exists
    final existingUser = await checkUserExists(email, username);
    if (existingUser != null) {
      if (existingUser[_dbHelper.colEmail] == email) {
        throw Exception('Email already exists');
      }
      if (existingUser[_dbHelper.colUsername] == username) {
        throw Exception('Username already exists');
      }
    }

    // Insert new user
    final userId = await _dbHelper.insertUser({
      _dbHelper.colUsername: username,
      _dbHelper.colEmail: email,
      _dbHelper.colPassword: password, // In production, hash this password!
      _dbHelper.colFullName: fullName,
      _dbHelper.colCreatedAt: DateTime.now().toIso8601String(),
      _dbHelper.colUpdatedAt: DateTime.now().toIso8601String(),
    });

    // Return user data
    return {
      'id': userId,
      'username': username,
      'email': email,
      'fullName': fullName,
    };
  }

  // Login user
  Future<Map<String, dynamic>?> loginUser({
    required String email,
    required String password,
  }) async {
    final db = await _dbHelper.database;

    final users = await db.query(
      _dbHelper.tableUsers,
      where: '${_dbHelper.colEmail} = ? AND ${_dbHelper.colPassword} = ?',
      whereArgs: [email, password],
    );

    if (users.isNotEmpty) {
      final user = users.first;
      return {
        'id': user[_dbHelper.colId],
        'username': user[_dbHelper.colUsername],
        'email': user[_dbHelper.colEmail],
        'fullName': user[_dbHelper.colFullName],
      };
    }

    return null;
  }

  // Update password (for forgot password)
  Future<bool> updatePassword(String email, String newPassword) async {
    final db = await _dbHelper.database;

    final result = await db.update(
      _dbHelper.tableUsers,
      {
        _dbHelper.colPassword: newPassword,
        _dbHelper.colUpdatedAt: DateTime.now().toIso8601String(),
      },
      where: '${_dbHelper.colEmail} = ?',
      whereArgs: [email],
    );

    return result > 0;
  }
  Future<User?> getUserByUsername(String username) async {
    try {
      final db = await _dbHelper.database;
      final results = await db.query(
        DatabaseHelper().tableUsers,
        where: '${DatabaseHelper().colUsername} = ?',
        whereArgs: [username],
      );

      if (results.isNotEmpty) {
        return User.fromMap(results.first);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> getUserByEmail(String email) async {
    try {
      final db = await _dbHelper.database;
      final results = await db.query(
        DatabaseHelper().tableUsers,
        where: '${DatabaseHelper().colEmail} = ?',
        whereArgs: [email],
      );

      if (results.isNotEmpty) {
        return User.fromMap(results.first);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
  Future<bool> checkIfEmailExists(String email) async {
    try {
      final user = await getUserByEmail(email);
      return user != null;
    } catch (e) {
      rethrow;
    }
  }
}