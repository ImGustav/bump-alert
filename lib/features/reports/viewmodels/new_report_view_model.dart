import 'dart:io';

import '../../../core/viewmodel/view_model.dart';

import '../../../core/services/location_service.dart';
import '../../../core/services/photo_service.dart';
import '../domain/report.dart';
import '../domain/report_repository.dart';

/// Estado e ações do formulário de denúncia (CÂMERA + GPS).
class NewReportViewModel extends ViewModel {
  NewReportViewModel({
    required ReportRepository repository,
    required PhotoService photoService,
    required LocationService locationService,
    ReportType initialType = ReportType.buraco,
    this.latitude,
    this.longitude,
    this.fromBump = false,
  }) : _repository = repository,
       _photoService = photoService,
       _locationService = locationService,
       type = initialType {
    if (latitude == null) getLocation();
  }

  final ReportRepository _repository;
  final PhotoService _photoService;
  final LocationService _locationService;
  final bool fromBump;

  ReportType type;
  File? photo;
  double? latitude;
  double? longitude;
  bool locating = false;
  String? locationError;
  bool saving = false;

  bool get hasLocation => latitude != null && longitude != null;

  void setType(ReportType t) {
    type = t;
    notifyListeners();
  }

  /// Retorna uma mensagem de erro, ou null se deu certo.
  Future<String?> takePhoto() async {
    try {
      final file = await _photoService.takePhoto();
      if (file != null) {
        photo = file;
        notifyListeners();
      }
      return null;
    } catch (e) {
      return 'Não foi possível usar a câmera: $e';
    }
  }

  Future<void> getLocation() async {
    locating = true;
    locationError = null;
    notifyListeners();
    try {
      final pos = await _locationService.getCurrentPosition();
      latitude = pos.latitude;
      longitude = pos.longitude;
    } catch (e) {
      locationError = e.toString();
    } finally {
      locating = false;
      notifyListeners();
    }
  }

  /// Retorna uma mensagem de erro, ou null se salvou.
  Future<String?> save() async {
    if (photo == null) return 'Tire uma foto do problema.';
    if (!hasLocation) return 'Aguarde a localização.';
    saving = true;
    notifyListeners();
    await _repository.add(
      Report(
        type: type,
        photoPath: photo!.path,
        latitude: latitude!,
        longitude: longitude!,
        createdAt: DateTime.now(),
        fromBump: fromBump,
      ),
    );
    saving = false;
    notifyListeners();
    return null;
  }
}
