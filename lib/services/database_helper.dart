import 'dart:async';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:uuid/uuid.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;
  final _storage = const FlutterSecureStorage();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<String> _getDatabasePassword() async {
    String? password = await _storage.read(key: 'db_password');
    if (password == null) {
      password = const Uuid().v4();
      await _storage.write(key: 'db_password', value: password);
    }
    return password;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'carejournal.db');
    String password = await _getDatabasePassword();

    return await openDatabase(
      path,
      version: 1,
      password: password,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE log_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        timestamp TEXT NOT NULL,
        entry_type TEXT NOT NULL,
        title TEXT NOT NULL,
        data TEXT,
        notes TEXT,
        report_tag INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future<void> insertLogEntry(Map<String, dynamic> row) async {
    final db = await database;
    await db.insert('log_entries', row);
  }

  Future<List<Map<String, dynamic>>> getLogEntries() async {
    final db = await database;
    return await db.query('log_entries', orderBy: 'timestamp DESC');
  }
}
