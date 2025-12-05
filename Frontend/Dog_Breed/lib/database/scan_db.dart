import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ScanDB {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  static Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "scan_history.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute("""
        CREATE TABLE scans(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          imagePath TEXT,
          breedName TEXT,
          formattedBreedName TEXT,
          confidence REAL,
          timestamp TEXT,
          isFavorite INTEGER
        )
        """);
      },
    );
  }

  // Insert Scan
  static Future<int> insertScan(Map<String, dynamic> scan) async {
    final db = await database;
    return await db.insert("scans", scan);
  }

  // Fetch All Scans
  static Future<List<Map<String, dynamic>>> getScans() async {
    final db = await database;
    return await db.query(
      "scans",
      orderBy: "id DESC",
    );
  }

  // Update Favorite
  static Future<int> updateFavorite(int id, bool isFavorite) async {
    final db = await database;
    return await db.update(
      "scans",
      {"isFavorite": isFavorite ? 1 : 0},
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
