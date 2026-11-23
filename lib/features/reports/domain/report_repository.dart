import 'report.dart';

abstract class ReportRepository {
  Future<List<Report>> getAll();
  Future<void> add(Report report);
  Future<void> remove(Report report);

  Stream<void> get onChanged;
}
