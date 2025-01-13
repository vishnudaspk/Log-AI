import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';

class LedgerDB {
  // Open database with logging
  static Future<Database> _openDB() async {
    final dbPath = await getDatabasesPath();
    final fullPath = join(dbPath, 'ledger.db');
    debugPrint('Opening database at path: $fullPath');

    return openDatabase(
      fullPath,
      onCreate: (db, version) {
        debugPrint('Creating table: ledger');
        return db.execute(
          'CREATE TABLE ledger(timestamp TEXT PRIMARY KEY, log TEXT)',
        );
      },
      version: 1,
    );
  }

  // Insert log with logging
  static Future<void> insertLog(String log) async {
    final db = await _openDB();
    final timestamp = DateTime.now().toIso8601String();
    debugPrint('Inserting log at $timestamp: $log');
    await db.insert('ledger', {'timestamp': timestamp, 'log': log});
    debugPrint('Log successfully inserted.');
  }

  // Retrieve today's logs with logging
  static Future<List<String>> getTodayLogs() async {
    final db = await _openDB();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    debugPrint('Fetching logs for today: $today');
    final logs = await db.query(
      'ledger',
      where: 'timestamp LIKE ?',
      whereArgs: ['$today%'],
    );
    debugPrint('Logs fetched for today: ${logs.length} entries found.');
    return logs.map((e) => e['log'] as String).toList();
  }

  // Retrieve all logs with logging
  static Future<List<Map<String, dynamic>>> getAllLogs() async {
    final db = await _openDB();
    debugPrint('Fetching all logs from the database.');
    final logs = await db.query('ledger');
    debugPrint('All logs fetched: ${logs.length} entries found.');
    return logs;
  }

  // Update log with logging
  static Future<void> updateLog(String timestamp, String updatedLog) async {
    final db = await _openDB();
    debugPrint('Updating log at $timestamp with new value: $updatedLog');
    await db.update(
      'ledger',
      {'log': updatedLog},
      where: 'timestamp = ?',
      whereArgs: [timestamp],
    );
    debugPrint('Log at $timestamp successfully updated.');
  }

  // Delete log with logging
  static Future<void> deleteLog(String timestamp) async {
    final db = await _openDB();
    debugPrint('Deleting log at $timestamp');
    await db.delete(
      'ledger',
      where: 'timestamp = ?',
      whereArgs: [timestamp],
    );
    debugPrint('Log at $timestamp successfully deleted.');
  }
}
