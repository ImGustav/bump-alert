import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../features/reports/data/report_local_datasource.dart';

Future<Database> openAppDatabase() async {
  final dir = await getDatabasesPath();
  return openDatabase(
    join(dir, 'olho_na_rua.db'),
    version: 2,
    onCreate: (db, _) => db.execute(ReportLocalDataSource.createTable),
    onUpgrade: (db, _, _) async {
      await db.execute('DROP TABLE IF EXISTS reports');
      await db.execute(ReportLocalDataSource.createTable);
    },
  );
}
