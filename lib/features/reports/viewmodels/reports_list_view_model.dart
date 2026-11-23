import 'dart:async';

import '../../../core/viewmodel/view_model.dart';

import '../domain/report.dart';
import '../domain/report_repository.dart';

/// Mantém a lista de denúncias sempre atualizada com o repositório.
class ReportsListViewModel extends ViewModel {
  ReportsListViewModel(this._repository) {
    _sub = _repository.onChanged.listen((_) => load());
    load();
  }

  final ReportRepository _repository;
  late final StreamSubscription<void> _sub;

  List<Report> reports = [];

  Future<void> load() async {
    reports = await _repository.getAll();
    notifyListeners();
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
