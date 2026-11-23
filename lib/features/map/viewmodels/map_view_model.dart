import 'dart:async';

import '../../../core/viewmodel/view_model.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/services/location_service.dart';
import '../../reports/domain/report.dart';
import '../../reports/domain/report_repository.dart';

/// Estado do mapa: posição atual + denúncias registradas.
class MapViewModel extends ViewModel {
  MapViewModel(this._repository, this._location) {
    _sub = _repository.onChanged.listen((_) => loadReports());
    loadReports();
  }

  final ReportRepository _repository;
  final LocationService _location;
  late final StreamSubscription<void> _sub;

  List<Report> reports = [];
  LatLng? myPosition;

  Future<void> loadReports() async {
    reports = await _repository.getAll();
    notifyListeners();
  }

  /// Retorna uma mensagem de erro, ou null se achou a posição.
  Future<String?> locateMe() async {
    try {
      final pos = await _location.getCurrentPosition();
      myPosition = LatLng(pos.latitude, pos.longitude);
      notifyListeners();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
