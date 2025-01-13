import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';

class SummaryDB {
  // Open database with logging
  static Future<Database> _openDB() async {
    final dbPath = await getDatabasesPath();
    final fullPath = join(dbPath, 'summary.db');
    debugPrint('Opening database at path: $fullPath');

    return openDatabase(
      fullPath,
      onCreate: (db, version) {
        debugPrint('Creating table: summary');
        return db.execute(
          'CREATE TABLE summary(timestamp TEXT PRIMARY KEY, text_compile TEXT, summary TEXT)',
        );
      },
      version: 1,
    );
  }

  // Insert summary with logging
  static Future<void> insertSummary(String textCompile, String summary) async {
    final db = await _openDB();
    final timestamp = DateTime.now().toIso8601String();

    // Log JSON-like structure before insertion
    debugPrint('Preparing to insert data into summary table:');
    debugPrint('Timestamp: $timestamp');
    debugPrint('Text Compile (raw): $textCompile');
    debugPrint('Summary (raw): $summary');

    await db.insert('summary', {
      'timestamp': timestamp,
      'text_compile': textCompile,
      'summary': summary,
    });

    // Confirm successful insertion
    debugPrint('Data successfully inserted into summary table.');
  }

  // Additional helper methods can also include logging
}
