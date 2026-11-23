import '../core/database/app_database.dart';
import '../core/services/location_service.dart';
import '../core/services/notification_service.dart';
import '../core/services/photo_service.dart';
import '../features/reports/data/report_local_datasource.dart';
import '../features/reports/data/report_repository_impl.dart';
import '../features/reports/domain/report_repository.dart';

/// Injeção de dependência simples (composition root).
/// Tudo é criado uma vez aqui e os ViewModels recebem o que precisam.
/// Em apps maiores, isso costuma ser feito com get_it ou Riverpod.
class Dependencies {
  Dependencies._(this.reportRepository);

  final ReportRepository reportRepository;
  final LocationService location = LocationService();
  final PhotoService photo = PhotoService();
  final NotificationService notifications = NotificationService.instance;

  static late final Dependencies instance;

  static Future<void> init() async {
    final db = await openAppDatabase();
    instance = Dependencies._(ReportRepositoryImpl(ReportLocalDataSource(db)));
    await NotificationService.instance.init();
  }
}

/// Atalho: `deps.reportRepository`, `deps.location`...
Dependencies get deps => Dependencies.instance;
