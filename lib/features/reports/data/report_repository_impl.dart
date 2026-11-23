import 'dart:async';
import 'dart:io';

import '../domain/report.dart';
import '../domain/report_repository.dart';
import 'report_local_datasource.dart';

class ReportRepositoryImpl implements ReportRepository {
  ReportRepositoryImpl(this._local);

  final ReportLocalDataSource _local;
  final _changes = StreamController<void>.broadcast();

  @override
  Stream<void> get onChanged => _changes.stream;

  @override
  Future<List<Report>> getAll() => _local.getAll();

  @override
  Future<void> add(Report report) async {
    await _local.insert(report);
    _changes.add(null);
  }

  @override
  Future<void> remove(Report report) async {
    await _local.delete(report.id!);
    final path = report.photoPath;
    if (path != null && await File(path).exists()) await File(path).delete();
    _changes.add(null);
  }
}
