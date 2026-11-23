import 'package:flutter/material.dart';

import '../../../app/dependencies.dart';
import '../domain/report.dart';
import '../viewmodels/new_report_view_model.dart';

/// Formulário de denúncia: CÂMERA + GPS na mesma tela.
///
/// Quando aberta pela notificação de solavanco, já vem com tipo "Buraco"
/// e as coordenadas do local do solavanco.
class NewReportPage extends StatefulWidget {
  const NewReportPage({
    super.key,
    this.initialType = ReportType.buraco,
    this.initialLatitude,
    this.initialLongitude,
    this.fromBump = false,
  });

  final ReportType initialType;
  final double? initialLatitude;
  final double? initialLongitude;
  final bool fromBump;

  @override
  State<NewReportPage> createState() => _NewReportPageState();
}

class _NewReportPageState extends State<NewReportPage> {
  late final _vm = NewReportViewModel(
    repository: deps.reportRepository,
    photoService: deps.photo,
    locationService: deps.location,
    initialType: widget.initialType,
    latitude: widget.initialLatitude,
    longitude: widget.initialLongitude,
    fromBump: widget.fromBump,
  );

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _takePhoto() async {
    final error = await _vm.takePhoto();
    if (error != null && mounted) _snack(error);
  }

  Future<void> _save() async {
    final error = await _vm.save();
    if (!mounted) return;
    if (error != null) return _snack(error);
    _snack('Denúncia registrada! Obrigado por cuidar da cidade.');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Nova denúncia')),
      body: ListenableBuilder(
        listenable: _vm,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (_vm.fromBump)
              Card(
                color: scheme.tertiaryContainer,
                child: const ListTile(
                  leading: Icon(Icons.vibration),
                  title: Text('Solavanco detectado neste local'),
                  subtitle: Text('Tire uma foto para confirmar o buraco.'),
                ),
              ),
            // ---------- CÂMERA ----------
            AspectRatio(
              aspectRatio: 4 / 3,
              child: InkWell(
                onTap: _takePhoto,
                borderRadius: BorderRadius.circular(16),
                child: Ink(
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: _vm.photo == null
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.photo_camera, size: 56),
                            SizedBox(height: 8),
                            Text('Toque para fotografar o problema'),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(_vm.photo!, fit: BoxFit.cover),
                        ),
                ),
              ),
            ),
            if (_vm.photo != null)
              TextButton.icon(
                onPressed: _takePhoto,
                icon: const Icon(Icons.refresh),
                label: const Text('Tirar outra foto'),
              ),
            const SizedBox(height: 16),
            // ---------- TIPO ----------
            DropdownButtonFormField<ReportType>(
              initialValue: _vm.type,
              decoration: const InputDecoration(
                labelText: 'Tipo de problema',
                border: OutlineInputBorder(),
              ),
              items: [
                for (final t in ReportType.values)
                  DropdownMenuItem(
                    value: t,
                    child: Text('${t.emoji}  ${t.label}'),
                  ),
              ],
              onChanged: (t) => _vm.setType(t!),
            ),
            const SizedBox(height: 12),
            // ---------- GPS ----------
            Card(
              child: ListTile(
                leading: const Icon(Icons.location_on),
                title: _vm.locating
                    ? const Text('Obtendo localização...')
                    : _vm.hasLocation
                    ? Text(
                        'Lat: ${_vm.latitude!.toStringAsFixed(6)}\n'
                        'Lng: ${_vm.longitude!.toStringAsFixed(6)}',
                      )
                    : Text(_vm.locationError ?? 'Sem localização'),
                trailing: _vm.locating
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : IconButton(
                        tooltip: 'Atualizar localização',
                        icon: const Icon(Icons.gps_fixed),
                        onPressed: _vm.getLocation,
                      ),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _vm.saving ? null : _save,
              icon: const Icon(Icons.send),
              label: const Text('Registrar denúncia'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
