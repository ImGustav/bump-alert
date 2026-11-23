import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../features/reports/data/report_local_datasource.dart';

/// Abre (e cria, na primeira vez) o banco SQLite do app.
Future<Database> openAppDatabase() async {
  final dir = await getDatabasesPath();
  return openDatabase(
    join(dir, 'olho_na_rua.db'),
    version: 1,
    onCreate: (db, _) => db.execute(ReportLocalDataSource.createTable),
  );
}
