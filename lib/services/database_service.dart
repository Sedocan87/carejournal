import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();
  factory DatabaseService() => instance;
  DatabaseService._internal();

  static Database? _database;
  static const _dbName = 'carejournal.db';
  static const _dbVersion = 2; // Incremented version
  static const _logEntriesTable = 'log_entries';
  static const _tagsTable = 'tags';
  static const _logEntryTagsTable = 'log_entry_tags';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<String> getDbPath() async {
    final documentsDirectory = await getDatabasesPath();
    return join(documentsDirectory, _dbName);
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
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

  Future<bool> isPasswordSet() async {
    const storage = FlutterSecureStorage();
    final password = await storage.read(key: 'db_password');
    return password != null;
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
      onUpgrade: _onUpgrade, // Added onUpgrade
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
    await _createTagsTables(db);
  }

  // New method for upgrading
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createTagsTables(db);
    }
  }

  // New method to create tags tables
  Future<void> _createTagsTables(Database db) async {
    await db.execute('''
      CREATE TABLE $_tagsTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE
      )
    ''');

    await db.execute('''
      CREATE TABLE $_logEntryTagsTable (
        log_entry_id INTEGER NOT NULL,
        tag_id INTEGER NOT NULL,
        PRIMARY KEY (log_entry_id, tag_id),
        FOREIGN KEY (log_entry_id) REFERENCES $_logEntriesTable (id) ON DELETE CASCADE,
        FOREIGN KEY (tag_id) REFERENCES $_tagsTable (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<int> insertLogEntry(Map<String, dynamic> row, List<String> tags) async {
    final db = await database;
    final logEntryId = await db.insert(_logEntriesTable, row);

    for (final tagName in tags) {
      final tagId = await _getOrCreateTag(tagName);
      await db.insert(_logEntryTagsTable, {
        'log_entry_id': logEntryId,
        'tag_id': tagId,
      });
    }
    return logEntryId;
  }

  Future<int> _getOrCreateTag(String tagName) async {
    final db = await database;
    final existingTag = await db.query(
      _tagsTable,
      where: 'name = ?',
      whereArgs: [tagName],
    );

    if (existingTag.isNotEmpty) {
      return existingTag.first['id'] as int;
    } else {
      return await db.insert(_tagsTable, {'name': tagName});
    }
  }
  
  Future<List<String>> getTagsForLogEntry(int logEntryId) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT T.name
      FROM $_tagsTable T
      INNER JOIN $_logEntryTagsTable LT ON T.id = LT.tag_id
      WHERE LT.log_entry_id = ?
    ''', [logEntryId]);
    return result.map((row) => row['name'] as String).toList();
  }

  Future<List<String>> getAllTags() async {
    final db = await database;
    final result = await db.query(_tagsTable, orderBy: 'name ASC');
    return result.map((row) => row['name'] as String).toList();
  }

  Future<List<Map<String, dynamic>>> getLogEntries({
    String? searchQuery,
    List<String>? tags,
    String? entryType,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await database;

    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (searchQuery != null && searchQuery.isNotEmpty) {
      whereClause += '(title LIKE ? OR notes LIKE ?)';
      final query = '%$searchQuery%';
      whereArgs.addAll([query, query]);
    }

    if (entryType != null && entryType.isNotEmpty) {
      if (whereClause.isNotEmpty) {
        whereClause += ' AND ';
      }
      whereClause += 'entry_type = ?';
      whereArgs.add(entryType.toLowerCase());
    }

    if (startDate != null) {
      if (whereClause.isNotEmpty) {
        whereClause += ' AND ';
      }
      whereClause += 'timestamp >= ?';
      whereArgs.add(startDate.toIso8601String());
    }

    if (endDate != null) {
      if (whereClause.isNotEmpty) {
        whereClause += ' AND ';
      }
      whereClause += 'timestamp <= ?';
      whereArgs.add(endDate.toIso8601String());
    }

    if (tags != null && tags.isNotEmpty) {
      if (whereClause.isNotEmpty) {
        whereClause += ' AND ';
      }
      final placeholders = tags.map((_) => '?').join(',');
      whereClause += '''
        id IN (
          SELECT log_entry_id
          FROM $_logEntryTagsTable
          INNER JOIN $_tagsTable ON $_logEntryTagsTable.tag_id = $_tagsTable.id
          WHERE $_tagsTable.name IN ($placeholders)
          GROUP BY log_entry_id
          HAVING COUNT(DISTINCT $_tagsTable.name) = ?
        )
      ''';
      whereArgs.addAll(tags);
      whereArgs.add(tags.length);
    }

    return await db.query(
      _logEntriesTable,
      where: whereClause.isEmpty ? null : whereClause,
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      orderBy: 'timestamp DESC',
    );
  }
}