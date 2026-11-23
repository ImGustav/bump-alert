import 'package:flutter/foundation.dart';

/// Base dos ViewModels do app.
///
/// Evita o erro "used after being disposed": se uma operação assíncrona
/// (GPS, banco) terminar depois que a tela foi fechada, o aviso é ignorado.
abstract class ViewModel extends ChangeNotifier {
  bool _disposed = false;

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
