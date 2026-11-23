import 'package:sqflite/sqflite.dart';

import '../domain/report.dart';
import 'report_model.dart';

class ReportLocalDataSource {
  ReportLocalDataSource(this._db);

  final Database _db;

  static const createTable = '''
    CREATE TABLE reports (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      photo_path TEXT,
      latitude REAL NOT NULL,
      longitude REAL NOT NULL,
      created_at INTEGER NOT NULL,
      from_bump INTEGER NOT NULL DEFAULT 0
    )
  ''';

  Future<List<Report>> getAll() async {
    final rows = await _db.query('reports', orderBy: 'created_at DESC');
    return rows.map(reportFromMap).toList();
  }

  Future<void> insert(Report r) => _db.insert('reports', r.toMap());

  Future<void> delete(int id) =>
      _db.delete('reports', where: 'id = ?', whereArgs: [id]);
}
