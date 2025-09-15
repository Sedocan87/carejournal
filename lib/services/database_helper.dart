import 'dart:async';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Future<void> insertLogEntry(Map<String, dynamic> row) async {
    // Do nothing
  }

  Future<List<Map<String, dynamic>>> getLogEntries() async {
    return [];
  }
}
