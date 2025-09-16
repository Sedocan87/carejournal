import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;
  static const _dbName = 'carejournal.db';
  static const _dbVersion = 1;
  static const _logEntriesTable = 'log_entries';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<String> _getDatabasePassword() async {
    const storage = FlutterSecureStorage();
    String? password = await storage.read(key: 'db_password');
    if (password == null) {
      password = const Uuid().v4();
      await storage.write(key: 'db_password', value: password);
    }
    return password;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getDatabasesPath();
    final path = join(documentsDirectory, _dbName);
    final password = await _getDatabasePassword();

    return await openDatabase(
      path,
      version: _dbVersion,
      password: password,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_logEntriesTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        timestamp TEXT NOT NULL,
        entry_type TEXT NOT NULL,
        title TEXT NOT NULL,
        data TEXT,
        notes TEXT,
        report_tag INTEGER NOT NULL
      )
    ''');
  }

  Future<void> insertLogEntry(Map<String, dynamic> row) async {
    final db = await database;
    await db.insert(_logEntriesTable, row);
  }

  Future<List<Map<String, dynamic>>> getLogEntries() async {
    final db = await database;
    return await db.query(_logEntriesTable, orderBy: 'timestamp DESC');
  }
}