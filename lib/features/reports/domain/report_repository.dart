import 'report.dart';

/// Contrato do repositório. As telas dependem só desta abstração;
/// a implementação (SQLite hoje, uma API amanhã) fica na camada data.
abstract class ReportRepository {
  Future<List<Report>> getAll();
  Future<void> add(Report report);
  Future<void> remove(Report report);

  /// Emite sempre que a lista de denúncias muda (para mapa/lista se atualizarem).
  Stream<void> get onChanged;
}
